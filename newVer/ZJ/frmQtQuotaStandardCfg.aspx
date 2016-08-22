<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtQuotaStandardCfg.aspx.cs" Inherits="QT_frmQtQuotaStandardCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
	 <div id="standar_toolbar"></div>
	 <div id="standar_form"></div>
	 <div id="standar_grid"></div>
</body><script>
var modify_quota_id = 'none';
var addmark = 0;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
Ext.onReady(function() {
   var Toolbar = new Ext.Toolbar({
   renderTo: "standar_toolbar",
       items: [{
           text: "新增",
           icon: '../Theme/1/images/extjs/customer/add16.gif',
           handler: function() {
               // saveType = "add";
               // openAddQuotaWin();//点击后，弹出添加信息窗口
               addmark = 1;
               formulaWindow.show();
           }
       }, '-', {
           text: "修改",
           icon: '../Theme/1/images/extjs/customer/edit16.gif',
           handler: function() {
               ///  deleteCustomer();

               var selectData = quotaGrid.getSelectionModel().getCount();
               if (selectData == 0) {
                   Ext.Msg.alert("提示", "请选中要修改的记录！");
                   return;
               }
               if (selectData > 1) {
                   Ext.Msg.alert("提示", "一次只能修改一条记录！");
                   return;
               }
               addmark = 0;
               modifyQuota(selectData);

           }
       }, '-', {
           text: "删除",
           icon: '../Theme/1/images/extjs/customer/delete16.gif',
           handler: function() {

               var selectData = quotaGrid.getSelectionModel().getCount();
               if (selectData == 0) {
                   Ext.Msg.alert("提示", "请选中要删除的行！");
                   return;
               }
               delQuota(selectData);

           }
        }]
    });

   function delQuota(rownum) {
       var ids = "";
       var recorddel = quotaGrid.getSelectionModel().getSelections();
       if (rownum == 1) {
           ids = recorddel[0].data.StandardNo;
       } else {
           for (var i = 0; i < rownum; i++) {
               ids += recorddel[i].data.StandardNo + ',';
           }
           ids = ids.substring(0, ids.length - 1);
       }

       Ext.Ajax.request({ 
           url: 'frmQtQuotaStandardCfg.aspx?method=delStandard'
               , params: {
                   ids: ids
               },
           //成功时回调 
           success: function(response, options) {
               //获取响应的json字符串

               Ext.Msg.alert("提示", "删除成功！");

               for (var i = 0; i < recorddel.length; i++) {
                   customerListStore.remove(recorddel[i]);
               }
           },
           failure: function() {
               Ext.Msg.alert("提示", "删除失败！");
           }
       });
   }


   //上限符号
   var UpperCombo = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
           url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Upper'
           }),
           // create reader that reads the project records
           reader: new Ext.data.JsonReader({ root: 'root' }, [
                { name: 'name', type: 'string' },
                { name: 'id', type: 'string' }

               ])
       }),
       valueField: 'id',
       displayField: 'name',
       mode: 'local',
       allowBlank: false,
       blankText: '上限运算符',
       forceSelection: true,
       emptyText: '上限运算符',
       editable: false,
       triggerAction: 'all',
       fieldLabel: '上限运算符',
       selectOnFocus: true,
       anchor: '60%'
   });
   //下限符号
   var LowerCombo = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
               url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Lower'
           }),
           // create reader that reads the project records
           reader: new Ext.data.JsonReader({ root: 'root' }, [
                { name: 'name', type: 'string' },
                { name: 'id', type: 'string' }

               ])
       }),
       valueField: 'id',
       displayField: 'name',
       mode: 'local',
       allowBlank: false,
       blankText: '下限运算符',
       forceSelection: true,
       emptyText: '下限运算符',
       editable: false,
       triggerAction: 'all',
       fieldLabel: '下限运算符',
       selectOnFocus: true,
       anchor: '60%'
   });

   //等级
   var StandarCom = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
               url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Standar'
           }),
           // create reader that reads the project records
           reader: new Ext.data.JsonReader({ root: 'root' }, [
                { name: 'name', type: 'string' },
                { name: 'id', type: 'string' }

               ])
       }),
       valueField: 'id',
       displayField: 'name',
       mode: 'local',
       allowBlank: false,
       blankText: '等级',
       forceSelection: true,
       emptyText: '等级',
       editable: false,
       triggerAction: 'all',
       fieldLabel: '等级',
       selectOnFocus: true,
       anchor: '90%'
   });
   if (typeof (formulaWindow) == "undefined") {//解决创建2个windows问题
       var formulaWindow = new Ext.Window({
           title: '合格标准配置',
           modal: 'true',
           width: 480,
           autoHeigth: true,
           collapsible: true, //是否可以折叠 
           closable: true, //是否可以关闭 
           //maximizable : true,//是否可以最大化 
           closeAction: 'hide',
           constrain: true,
           resizable: false,
           plain: true,
           // ,items: addQuotaForm
           buttons: [{
               text: '保存后关闭',
               handler: function() {
                   addFormula(true);
               }
           },{
               text: '保存后继续新增',
               handler: function() {
                   addFormula(false);
               }
           }, {
               text: '关闭',
               handler: function() {
                   formulaWindow.hide();
                   editFmForm.getForm().reset();
               }
            }]
       });
   }
                     
                    
   var quotaItemComb = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
           url: 'frmQtQuotaItemCfg.aspx?method=getAllCfgList'
           }),
           // create reader that reads the project records
           reader: new Ext.data.JsonReader({ root: 'root' }, [
                { name: 'QuotaName', type: 'string' },
                { name: 'QuotaNo', type: 'string' },
                { name: 'QuotaUnit', type: 'string' }
            ])
        }),
       listeners: {
           select: function(combo, record, index) {
           Ext.getCmp('realname').setValue(record.data.QuotaName);
           Ext.getCmp('unit').setValue(record.data.QuotaUnit);
           }
       }	                               ,
       displayField: 'QuotaName',
       valueField: 'QuotaNo',
       triggerAction: 'all',
       id: 'quotaitemCombo',
       //pageSize: 5,
       //minChars: 2,
       //hideTrigger: true,
       fieldLabel: '指标名称',
       typeAhead: true,
       mode: 'local',
       //            tpl: resultTpl,
       emptyText: '',
       selectOnFocus: false,
       editable: true,
       anchor: '90%'
   });


   function addFormula(closeflag) {
       var quotaid = quotaItemComb.getValue();
       if (quotaid == null || quotaid == 'undefined' || quotaid == '') {

           Ext.Msg.alert("提示", "请选择指标名称！");
           return;
       }
       var unit = Ext.getCmp("unit").getValue();
     /*  if (unit == null || unit.trim() == '') {
           Ext.Msg.alert("提醒", "指标单位不能为空！");
           return;
       }*/
       var note = Ext.getCmp("note").getValue();
      /* if (note == null || note.trim() == '') {
           Ext.Msg.alert("提醒", "备注不能为空！");
           return;
       }*/
       var fum = Ext.getCmp("standar").getValue();
       /*if (fum == null || fum.trim() == '') {
           Ext.Msg.alert("提醒", "合格标准不能为空！");
           return;
       }*/ 
       var Lowernum = Ext.getCmp("Lowernum").getValue();
     /* if (Lowernum == null || Lowernum.trim() == '') {
           Ext.Msg.alert("提醒", "下限值不能为空！");
           return;
       }*/
       var Uppernum = Ext.getCmp("Uppernum").getValue();
      /* if (Uppernum == null || Uppernum.trim() == '') {
           Ext.Msg.alert("提醒", "上限值不能为空！");
           return;
       }*/ 
       var grade = StandarCom.getValue();
       if (grade == null || grade == 'undefined' || grade == '') {

           Ext.Msg.alert("提示", "请选择等级！");
           return;
       }
       var Lower = LowerCombo.getValue();
      /* if (Lower == null || Lower == 'undefined' || Lower == '') {

           Ext.Msg.alert("提示", "请选择下限符号！");
           return;
       }*/
       var Upper =UpperCombo.getValue();
      /* if (Upper == null || Upper == 'undefined' || Upper == '') {

           Ext.Msg.alert("提示", "请选择上限符号！");
           return;
       }*/
       var qurl = 'frmQtQuotaStandardCfg.aspx?method=addStandard';
       if (modify_quota_id != '' && modify_quota_id != null && addmark == 0) {
           qurl = 'frmQtQuotaStandardCfg.aspx?method=updateStandard&standardno=' + modify_quota_id;
       }
       Ext.Ajax.request({
           url: qurl
           , params: {
             QuotaNo: quotaid
           , QuotaName: Ext.getCmp('realname').getValue()
           , QuotaUnit: unit
           , QuotaStandard: fum
           , QuotaNotes: note
           , QuotaRank:grade
           , QuotaUpper:Uppernum
           , QuotaLower:Lowernum
           , LowerOperator:Lower
           , UpperOperator:Upper           
           },
           //成功时回调 
           success: function(response, options) {
               //获取响应的json字符串
               Ext.Msg.alert("提示", "保存成功！");
               if(closeflag)
               {
                    formulaWindow.hide();
                    editFmForm.getForm().reset();
               }
               var formulaName = Ext.getCmp("serchFormulaName").getValue();
               customerListStore.baseParams.start=0;
               customerListStore.baseParams.limit=10;
               customerListStore.load({
                   params: {
                       key: formulaName
                   }
               });
           },
           failure: function() {
               Ext.Msg.alert("提示", "保存失败！");
           }
       });
   }
   //修改指标
   function modifyQuota(rownum) {

       // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);
       formulaWindow.show();
       var record = quotaGrid.getSelectionModel().getSelections()[rownum - 1].data;
       Ext.getCmp("unit").setValue(record.QuotaUnit);
       Ext.getCmp("realname").setValue(record.QuotaName);
       Ext.getCmp("standar").setValue(record.QuotaStandard);
       Ext.getCmp("note").setValue(record.QuotaNotes);
       Ext.getCmp("Lowernum").setValue(record.QuotaLower);
       Ext.getCmp("Uppernum").setValue(record.QuotaUpper);
       quotaItemComb.setValue(record.QuotaNo);
       StandarCom.setValue(record.QuotaRank);
       LowerCombo.setValue(record.LowerOperator);
       UpperCombo.setValue(record.UpperOperator);
       modify_quota_id = record.StandardNo;
   } 
    var editFmForm = new Ext.form.FormPanel({
        labelWidth: 80,
        autoWidth: true,
        frame: true,
        autoHeight: true,
        items: [
        {
            layout: 'column',
            items: [{
                columnWidth: .8,
                layout: 'form',
                border: false,
                items: [
                    quotaItemComb
                ]
            }]
        },
        {
            layout: 'column',
            items: [{
               columnWidth: 1,
               layout: 'form',
               border: false,
               items: [{
                   cls: 'key',
                   xtype: 'hidden',
                   name: 'realname',
                   id: 'realname',
                   anchor: '90%'
                }]
	        }]
        }, {
              layout: 'column',
              items: [{
               columnWidth: .5,
               layout: 'form',
               border: false,
               items: [{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: '单位',
                   name: 'unit',
                   id: 'unit',
                   anchor: '90%'
                }]
	        }]
        }, {
              layout: 'column',
              items: [{
                   columnWidth: .8,
                   layout: 'form',
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textarea',
                       height:40,
                       fieldLabel: '备注',
                       name: 'note',
                       id: 'note',
                       anchor: '90%'
                    }]
	            }]
        }, {
              layout: 'column',
              items: [{
                   columnWidth: .5,
                   layout: 'form',
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       fieldLabel: '合格标准',
                       name: 'standar',
                       id: 'standar',
                       anchor: '90%'
                    }]
	            }]
	    }, {
              layout: 'column',
              items: [{
                   columnWidth: .5,
                   layout: 'form',
                   border: false,
                   items: [
                        StandarCom
                   ]
                }]
        }, {
              layout: 'column',
              items: [{
                   columnWidth: .5,
                   layout: 'form',
                   border: false,
                   items: [
	                    LowerCombo
	               ]
	           }]
	    }, {
                layout: 'column',
                items: [{
                    columnWidth: .5,
                    layout: 'form',
                    border: false,
                    items: [{
                        cls: 'key',
                        xtype: 'textfield',
                        fieldLabel: '下限值',
                        name: 'Lowernum',
                        id: 'Lowernum',
                        anchor: '90%'
                    }]
	            }]
	    }, {
                layout: 'column',
                items: [{
                    columnWidth: .5,
                    layout: 'form',
                    border: false,
                    items: [
                        UpperCombo
                    ]
                }]
        }, {
                layout: 'column',
                items: [{
                    columnWidth: .5,
                    layout: 'form',
                    border: false,
                    items: [{
                        cls: 'key',
                        xtype: 'textfield',
                        fieldLabel: '上限值',
                        name: 'Uppernum',
                        id: 'Uppernum',
                        anchor: '90%'
                    }]
	            }]
        }]
    });

    function addToFum(str) {
       var fum = Ext.getCmp('fum').getValue();
       fum += str;
       Ext.getCmp('fum').setValue(fum);
    }
    formulaWindow.add(editFmForm);





    var quotaTemplate_form = new Ext.form.FormPanel({
       renderTo: "standar_form",
       frame: true,
       monitorValid: true, // 把有formBind:true的按钮和验证绑定
       layout: "form",     
       items: [{
           layout: 'column',   //定义该元素为布局为列布局方式
           border: false,
           labelSeparator: '：',
           items: [{
               columnWidth: .30,
               layout: 'form',
               border: false,
               labelWidth: 70,
               items: [{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: '指标项名称',
                   name: 'serchFormulaName',
                   id: 'serchFormulaName',
                   anchor: '90%'
                }]
            },
	        {
	            columnWidth: .10,
	            layout: 'form',
	            border: false,
	            items: [{ cls: 'key',
	                xtype: 'button',
	                text: '查询',
	                anchor: '50%',
	                handler: function() {
	                    queryFormula();
	                }
                }]
            }]
        }]
    });
   function queryFormula() {
       var formulaName = Ext.getCmp("serchFormulaName").getValue();
       customerListStore.baseParams.start=0;
       customerListStore.baseParams.limit=10;
       customerListStore.baseParams.key=formulaName;
       customerListStore.load()
   }

    var customerListStore = new Ext.data.Store
	({
	    url: 'frmQtQuotaStandardCfg.aspx?method=queryStandard',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	    { name: 'StandardNo' },
	    { name: 'QuotaNo' },
	   // { name: 'OrgName' },
        { name: 'QuotaName' },
	    { name: 'QuotaUnit' },
        { name: 'LowerOperator' },
        { name: 'LowerShow' },
        { name: 'QuotaLower' },
        { name: 'UpperShow' },
        { name: 'UpperOperator' },
        { name: 'QuotaUpper' },
        { name: 'QuotaRank' },
        { name: 'QuotaRankShow' },
	    { name: 'QuotaStandard' },
	    { name: 'QuotaNotes' }
	    ]),
	   listeners:
      {
          scope: this,
          load: function() {
              //数据加载预处理,可以做一些合并、格式处理等操作
          }
      }
	});
    var sm = new Ext.grid.CheckboxSelectionModel(
        {
            singleSelect: false
        }
    );
   var quotaGrid = new Ext.grid.GridPanel({
       el: 'standar_grid',
       width: '100%',
       height: '100%',
       autoWidth: true,
       autoHeight: true,
       autoScroll: true,
       layout: 'fit',
       id: 'customerdatagrid',
       store: customerListStore,
       loadMask: { msg: '正在加载数据，请稍侯……' },
       sm: sm,
       /*  如果中间没有查询条件form那么可以直接用tbar来实现增删改
       tbar:[{
       text:"添加",
       handler:this.showAdd,
       scope:this
       },"-",
       {
       text:"修改"
       },"-",{
       text:"删除",
       handler:this.deleteBranch,
       scope:this
       }],
       */
       cm: new Ext.grid.ColumnModel([
            sm,
            new Ext.grid.RowNumberer(), //自动行号
            { header: '合格标准号', hidden: true, dataIndex: 'StandardNo' },
         //   { header: '所属公司',  dataIndex: 'OrgName' },
            { header: '指标号', hidden: true, dataIndex: 'QuotaNo' },
            { header: '指标名称', dataIndex: 'QuotaName' },
            { header: '指标单位', dataIndex: 'QuotaUnit' },
	        { header: '下限符',hidden: true, dataIndex: 'LowerOperator' },
	        { header: '下限运算符', dataIndex: 'LowerShow' },
	        { header: '下限值', dataIndex: 'QuotaLower' },
	        { header: '上限符',hidden: true, dataIndex: 'UpperOperator' },
	        { header: '上限操作符', dataIndex: 'UpperShow' },
	        { header: '上限值', dataIndex: 'QuotaUpper' },
			{ header: '等级', hidden: true, dataIndex: 'QuotaRank' },
			{ header: '等级', dataIndex: 'QuotaRankShow' },
			{ header: '标准要求', dataIndex: 'QuotaStandard' },
			{ header: '备注', dataIndex: 'QuotaNotes' }
			]), listeners:
			  {
			      rowselect: function(sm, rowIndex, record) {
			          //alert(1);
			          //Ext.MessageBox.alert("提示", "您选择的出版号是：" + record.data.FormulaNo);
			      },
			      rowclick: function(grid, rowIndex, e) {
			     
			      },
			      rowdbclick: function(grid, rowIndex, e) {
			          //双击事件
			      },
			      cellclick: function(grid, rowIndex, columnIndex, e) {
			          //单元格单击事件			           
			      },
			      celldbclick: function(grid, rowIndex, columnIndex, e) {
			          //单元格双击事件
			          /*
			          var record = grid.getStore().getAt(rowIndex); //Get the Record
			          var fieldName = grid.getColumnModel().getDataIndex(columnIndex); //Get field name
			          var data = record.get(fieldName);
			          Ext.MessageBox.alert('show','当前选中的数据是'+data); 
			          */
			      }
			  },
               bbar: new Ext.PagingToolbar({
                   pageSize: 10,
                   store: customerListStore,
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
               //width: 750, 
               height: 265,
               closeAction: 'hide',

               stripeRows: true,
               loadMask: true,
               autoExpandColumn: 2
           });
           quotaGrid.render();

       }); 
		
	</script>
</html>

