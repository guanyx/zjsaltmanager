<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtStandardTemplateCfg.aspx.cs" Inherits="QT_frmQtStandardTemplateCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>

</head>
<body>	<div id="sdTemplate_toolbar"></div>
	    <div id="sdTemplate_form"></div>
	    <div id="sdTemplate_grid"></div>
	 </body><script>
	            var quotaCount;
	            var quotaArr = new Array();
	            var addmark = 0;
	            var quotaIdArr = null;
	            var quotaIdstr = '';
	            var modify_quota_template_id = "";
	            Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
	            Ext.onReady(function() {
	                /*     Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender
	                .createSequence(function() {
	                this.relayEvents(this.el, ['dblclick']);
	                });*/

	                var Toolbar = new Ext.Toolbar({
	                renderTo: "sdTemplate_toolbar",
	                    items: [{
	                        text: "新增",
	                        icon: '../Theme/1/images/extjs/customer/add16.gif',
	                        handler: function() {
	                            addmark = 1;
	                            formulaTemplateWindow.show();

	                        }
	                    }, '-', {
	                        text: "修改",
	                        icon: '../Theme/1/images/extjs/customer/edit16.gif',
	                        handler: function() {
	                            addmark = 0;
	                            var selectData = formulaTemplateGrid.getSelectionModel().getCount();
	                            if (selectData == 0) {
	                                Ext.Msg.alert("提示", "请选中要修改的记录！");
	                                return;
	                            }
	                            if (selectData > 1) {
	                                Ext.Msg.alert("提示", "一次只能修改一条记录！");
	                                return;
	                            }


	                            modifyFormulaTemplate(selectData);
	                        }
	                    }, '-', {
	                        text: "删除",
	                        icon: '../../Theme/1/images/extjs/customer/delete16.gif',
	                        handler: function() {
	                            var selectData = formulaTemplateGrid.getSelectionModel().getCount();
	                            if (selectData == 0) {
	                                Ext.Msg.alert("提示", "请选中要删除的行！");
	                                return;
	                            }
	                            delQuotaTemplate(selectData);
	                        }
}]
	                    });

	                    function delQuotaTemplate(rownum) {
	                        var ids = "";
	                        var recorddel = formulaTemplateGrid.getSelectionModel().getSelections();
	                        if (rownum == 1) {
	                            ids = recorddel[0].data.TemplateNo;
	                        } else {
	                            for (var i = 0; i < rownum; i++) {
	                                ids += recorddel[i].data.TemplateNo + ',';
	                            }
	                            ids = ids.substring(0, ids.length - 1);
	                        }

	                        Ext.Ajax.request({
	                            url: 'frmQtQualityTemplateCfg.aspx?method=delQuotaTemplate'
                                               , params: {
                                                   ids: ids
                                               },
	                            //成功时回调 
	                            success: function(response, options) {
	                                //获取响应的json字符串

	                                Ext.Msg.alert("提示", "删除成功！");

	                                for (var i = 0; i < recorddel.length; i++) {
	                                    fromulaTemplateStore.remove(recorddel[i]);
	                                }
	                            },
	                            failure: function() {
	                                Ext.Msg.alert("提示", "删除失败！");
	                            }
	                        });
	                    }

	                    function delGridSel() {
	                        var dsm = detailGrid.getSelectionModel();
	                        dsm.deselectRange(0, 1000);
	                    }
	                    if (typeof (formulaTemplateWindow) == "undefined") {//解决创建2个windows问题
	                        var formulaTemplateWindow = new Ext.Window({
	                            title: '新增合格标准模板',
	                            modal: 'true',
	                            width: 650,
	                            height: 430,
	                            // autoHeight: true,
	                            collapsible: true, //是否可以折叠 
	                            closable: true, //是否可以关闭 
	                            //maximizable : true,//是否可以最大化 
	                            closeAction: 'hide',
	                            constrain: true,
	                            resizable: false,
	                            plain: true,
	                            // ,items: addQuotaForm
	                            buttons: [{
	                                text: '保存',
	                                handler: function() {
	                                    addFomula();
	                                    //  formulaTemplateWindow.hide();
	                                }
	                            }, {
	                                text: '关闭',
	                                handler: function() {
	                                    formulaTemplateWindow.hide();
	                                    addFormulaTamplateForm.getForm().reset();
	                                    delGridSel();
	                                }
}]
	                            });
	                        }
	                       
	                        function modifyFormulaTemplate(rownum) {

	                            // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);

	                            formulaTemplateWindow.show();



	                            var record = formulaTemplateGrid.getSelectionModel().getSelections()[rownum - 1].data;
	                            Ext.getCmp("Template_Name").setValue(record.TemplateName);
	                            Ext.getCmp("Note").setValue(record.Note);
	                            modify_quota_template_id = record.TemplateNo;
	                            var sm = detailGrid.getSelectionModel();
	                            sm.clearSelections();
	                            Ext.Ajax.request({
	                                url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateDetail'
                                               , params: {
                                                   templateno: modify_quota_template_id
                                               },
	                                //成功时回调
	                                success: function(response, options) {
	                                    quotaIdArr = null;
	                                    quotaIdArr = '';
	                                    quotaIdstr = response.responseText;
	                                    quotaIdArr = (quotaIdstr.substring(1, quotaIdstr.length - 1)).split(",");

	                                    //  quotaIdArr = (quotaIdstr.substring(1, quotaIdstr.length - 1)).split(",");
	                                    //var record = formulaTemplateGrid.getSelectionModel();
	                                    var dsm = detailGrid.getSelectionModel();
	                                    dsm.clearSelections();
	                                    detailStore.each(function(detailStore, rec) { 
	                                        var fno = detailStore.data.StandardNo;
	                                        if (quotaIdstr.indexOf(',' + fno + ',') >= 0) {
	                                            dsm.selectRow(rec, true);
	                                        }
	                                    });



	                                },
	                                failure: function() {
	                                    Ext.Msg.alert("提示", "获取模板详细信息失败！");
	                                }
	                            });



	                        }




	                        function addFomula() {

	                            var tname = Ext.getCmp('Template_Name').getValue();
	                            if (tname == null || tname.trim() == '') {
	                                Ext.Msg.alert("提醒", "模板名称不能为空！");
	                                return;
	                            }
	                            var note = Ext.getCmp('Note').getValue();
	                          /*  if (note == null || note.trim() == '') {
	                                Ext.Msg.alert("提醒", "备注不能为空！");
	                                return;
	                            }*/ 
	                            var selectData = detailGrid.getSelectionModel().getCount();
	                            if (selectData == 0) {
	                                Ext.Msg.alert("提示", "请选择合格标准！");
	                                return;
	                            }
	                            var ids = '';
	                            var delstr = '';
	                            var addstr = '';
	                            var record = detailGrid.getSelectionModel().getSelections();
	                          
	                            if (selectData == 1) {
	                                ids = record[0].data.StandardNo;
	                            } else {
	                                for (var i = 0; i < selectData; i++) {
	                                    ids += record[i].data.StandardNo + ',';
	                                }
	                                ids = ids.substring(0, ids.length - 1);
	                            }


	                            if (modify_quota_template_id != '' && modify_quota_template_id != null && addmark == 0) {
	                                
	                                var compareArr = ids.split(",");
	                                var compareStr = "," + ids + ',';
	                                for (var t = 0; t < quotaIdArr.length; t++) {
	                                    var indexof = compareStr.indexOf(',' + quotaIdArr[t] + ',');
	                                    if (indexof < 0) {
	                                        delstr += quotaIdArr[t] + ',';
	                                    }
	                                }
	                                if (delstr.length > 1) {
	                                    delstr = delstr.substring(0, delstr.length - 1);
	                                }

	                                for (var r = 0; r < compareArr.length; r++) {
	                                    var indexof = quotaIdstr.indexOf(',' + compareArr[r] + ',');

	                                    if (indexof < 0) {
	                                        addstr += compareArr[r] + ',';
	                                    }
	                                }
	                                if (addstr.length > 1) {
	                                    addstr = addstr.substring(0, addstr.length - 1);
	                                }
	                            

	                                Ext.Ajax.request({
	                                url: 'frmQtQualityTemplateCfg.aspx?method=modifyQuotaTemplate&code=Q035'
                                          , params: {
                                              tempName: tname,
                                              templateno: modify_quota_template_id,
                                              note: note,
                                              delstr: delstr,
                                              addstr: addstr
                                          },
	                                    //成功时回调 
	                                    success: function(response, options) {
	                                        //获取响应的json字符串

	                                        Ext.Msg.alert("提示", "修改成功！");
	                                        formulaTemplateWindow.hide();
	                                        addFormulaTamplateForm.getForm().reset();
	                                        queryFormulaTemplate();
	                                    },
	                                    failure: function() {
	                                        Ext.Msg.alert("提示", "修改失败！");
	                                    }
	                                });



	                            } else {
	                            var qurl = 'frmQtStandardTemplateCfg.aspx?method=addStandard';
	                                Ext.Ajax.request({
	                                    url: qurl
                               , params: {
                                   tempName: tname,
                                   note: note,
                                   ids: ids
                               },
	                                    //成功时回调 
	                                    success: function(response, options) {
	                                        //获取响应的json字符串

	                                        Ext.Msg.alert("提示", "保存成功！");
	                                        formulaTemplateWindow.hide();
	                                        addFormulaTamplateForm.getForm().reset();
	                                        queryFormulaTemplate();

	                                    },
	                                    failure: function() {
	                                        Ext.Msg.alert("提示", "保存失败！");
	                                    }
	                                });
	                            }

	                        }

	                        var formulaTemplate_form = new Ext.form.FormPanel({
	                            renderTo: "sdTemplate_form",
	                            frame: true,
	                            monitorValid: true, // 把有formBind:true的按钮和验证绑定
	                            layout: "form",
	                           
	                            items: [{
	                                layout: 'column',   //定义该元素为布局为列布局方式
	                                border: false,
	                                labelSeparator: '：',
	                                items: [ {
	                                    columnWidth: .3,
	                                    layout: 'form',
	                                    border: false,
	                                    labelWidth: 55,
	                                    items: [{
	                                        cls: 'key',
	                                        xtype: 'textfield',
	                                        fieldLabel: '模板名称',
	                                        name: 'serchFormulaTemplateName',
	                                        id: 'serchFormulaTemplateName',

	                                        //  listeners: { click: function() { alert(1); } },
	                                        anchor: '90%'
}]
	                                    }
		,
		{
		    columnWidth: .10,
		    layout: 'form',
		    border: false,
		    items: [{ cls: 'key',
		        xtype: 'button',
		        text: '查询',
		        anchor: '50%',
		        handler: function() {
		            queryFormulaTemplate();
		        }
}]
}]
}]
	                                });




	                                var detailStore = new Ext.data.Store
			({
	            url: 'frmQtQuotaStandardCfg.aspx?method=queryStandard',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'StandardNo' },
	            { name: 'QuotaName' },
			    { name: 'QuotaUnit' },
	            { name: 'LowerShow' },
	            { name: 'QuotaLower' },
	            { name: 'UpperShow' }, 
	            { name: 'QuotaUpper' },
	            { name: 'QuotaRankShow' },
			    { name: 'QuotaStandard' },
			    { name: 'QuotaNotes' }
			    ])
			   ,
			    listeners:
			      {
			          scope: this,
			          load: function() {

			          }
			      }
			});
	                                var detailsm = new Ext.grid.CheckboxSelectionModel(
            {
                singleSelect: false
            }
        );
	                                var detailGrid = new Ext.grid.GridPanel({
	                                    //width: '100%',
	                                    //height: '100%',
	                                    //autoWidth: true,
	                                    height: 300,
	                                    autoScroll: true,
	                                    layout: 'fit',
	                                    id: 'detailsmgrid',
	                                    store: detailStore,
	                                    loadMask: { msg: '正在加载数据，请稍侯……' },
	                                    sm: detailsm,
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
                        detailsm,

                        new Ext.grid.RowNumberer(), //自动行号
                                            { header: '合格标准号', hidden: true, dataIndex: 'StandardNo' },
                                            { header: '指标名称', dataIndex: 'QuotaName' },
                                            { header: '指标单位', dataIndex: 'QuotaUnit',width:50 },
									        { header: '下限运算符', dataIndex: 'LowerShow',width:50 },
									        { header: '下限值', dataIndex: 'QuotaLower',width:60 },
									        { header: '上限操作符', dataIndex: 'UpperShow',width:50 },
									        { header: '上限值', dataIndex: 'QuotaUpper',width:60 },
											{ header: '等级', dataIndex: 'QuotaRankShow',width:60 },
											{ header: '标准要求', dataIndex: 'QuotaStandard',width:80 },
											{ header: '备注', dataIndex: 'QuotaNotes',width:120 }
			  ]), listeners:
			  {
			      rowselect: function(sm, rowIndex, record) {
			          //行选中
			          //Ext.MessageBox.alert("提示","您选择的出版号是：" + r.data.ASIN);
			      },
			      rowclick: function(grid, rowIndex, e) {
			          //双击事件
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

	                                    viewConfig: {
	                                        columnsText: '显示的列',
	                                        scrollOffset: 20,
	                                        sortAscText: '升序',
	                                        sortDescText: '降序',
	                                        forceFit: false
	                                    },


	                                    closeAction: 'hide',

	                                    stripeRows: true,
	                                    loadMask: true//,
	                                    //autoExpandColumn: 2
	                                });


	                                detailStore.load({
	                                    params: { start: 0, limit: 1000 }
	                                });
	                                var addFormulaTamplateForm = new Ext.form.FormPanel({
	                                    frame: true,
	                                    autoHeight:true,
	                                    monitorValid: true, // 把有formBind:true的按钮和验证绑定
	                                    labelWidth: 70,
	                                    items: [
                           {
                               items: [{
                                   layout: 'form',
                                   columnWidth: 1,  //该列占用的宽度，标识为20％
                                   border: false,
                                   items: [ {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '模板名称',
                                       name: 'Template_Name',
                                       id: 'Template_Name',
                                       anchor: '98%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '备注',
                                       name: 'Note',
                                       id: 'Note',
                                       anchor: '98%'
}]
}]
                                   }, {
                                       cls: 'key',
                                       fieldLabel: '标准选择项',
                                       items: [detailGrid],
                                       anchor: '98%'
}]

	                                });
	                                formulaTemplateWindow.add(addFormulaTamplateForm);
	                                function queryFormulaTemplate() {
	                                    var formulaName = Ext.getCmp("serchFormulaTemplateName").getValue();
	                                    
                                        fromulaTemplateStore.baseParams.start=0;
                                        fromulaTemplateStore.baseParams.limit=10;
	                                    fromulaTemplateStore.load({
	                                        params: {
	                                            key: formulaName
	                                        }
	                                    });
	                                }
	                                var fromulaTemplateStore = new Ext.data.Store
			                        ({
			                            url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateList&code=Q035',
			                            reader: new Ext.data.JsonReader({
			                                totalProperty: 'totalProperty',
			                                root: 'root'
			                            }, [
			                             { name: 'TemplateNo' },
			    { name: 'OrgName' },
	            { name: 'TemplateName' },
			    { name: 'Note' },
	            { name: 'EmpName' },
	            { name: 'CreateDate' }
			                            ])
			                           ,
			                            listeners:
			                              {
			                                  scope: this,
			                                  load: function() {

			                                  }
			                              }
			                        });
	                                var sm = new Ext.grid.CheckboxSelectionModel(
                                    {
                                        singleSelect: false
                                    }
                                );
	                                var formulaTemplateGrid = new Ext.grid.GridPanel({
	                                el: 'sdTemplate_grid',
	                                    width: '100%',
	                                    height: '100%',
	                                    autoWidth: true,
	                                    autoHeight: true,
	                                    autoScroll: true,
	                                    layout: 'fit',
	                                    id: 'formulaTemplateGrid',
	                                    store: fromulaTemplateStore,
	                                    loadMask: { msg: '正在加载数据，请稍侯……' },
	                                    sm: sm,

	                                    cm: new Ext.grid.ColumnModel([
                        sm,

                        new Ext.grid.RowNumberer(), //自动行号
                                           {header: '模板id', hidden: true, dataIndex: 'TemplateNo' },
									        { header: '公司名称', dataIndex: 'OrgName' },
									        { header: '模板名称', dataIndex: 'TemplateName' },
											{ header: '备注', dataIndex: 'Note' },
											{ header: '操作人', dataIndex: 'EmpName' },
											{ header: '操作时间', dataIndex: 'CreateDate' }
			  ]), listeners:
			  {
			      rowselect: function(sm, rowIndex, record) {
			          //行选中
			          //Ext.MessageBox.alert("提示","您选择的出版号是：" + r.data.ASIN);
			      },
			      rowclick: function(grid, rowIndex, e) {
			          //双击事件
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
	                                        store: fromulaTemplateStore,
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
	                                formulaTemplateGrid.render();



	                            }); 
		
	</script>
</html>
