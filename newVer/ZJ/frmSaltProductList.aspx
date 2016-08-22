<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSaltProductList.aspx.cs" Inherits="ZJ_frmSaltProductList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
	<script type="text/javascript" src="../js/operateResp.js"></script>
	<%=getComboBoxStore() %>
	<script type="text/javascript">

           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "qtSaltProduct_toolbar",
                   items: [{
                       text: "新增产品",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                            //新增盐品对应的品种信息
                            addProduct();
                       }
                   }, '-', {
                       text: "删除产品",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                            var productIds = selectedRow("请选择需要删除的盐品！");
                            delProduct(productIds);
                       }
}, '-', {
                       text: "产品等级",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                            var productIds = selectedRow("请选择需要设置等级的盐品！");
                            
                       }
}]
                   });
                       
        function selectedRow(message)
        {
            var sm = Ext.getCmp('qtSaltProductGrid').getSelectionModel();
            //获取选择的数据信息
            var record=sm.getSelections();
            if(record == null || record.length == 0)
            {
                Ext.Msg.alert('提示消息', '请选择需要设置的信息！');
                return;
            }

            var productIds = '';
            for(var i=0;i<record.length;i++)
            {
                if(productIds.length>0)
                    productIds+=",";
                productIds += record[i].get('ProductId');
            }
            return productIds;
        }            
        addTypesProductWin = null;
        function addProduct() {
            if (addTypesProductWin == null) {
                addTypesProductWin = ExtJsShowWin('添加供应商品信息', 'frmProductSelect.aspx?saltId=' + saltId, 'add', 800, 500);
                addTypesProductWin.show();
            }
            else {
                addTypesProductWin.show();
                parent.document.getElementById("iframeadd").contentWindow.saltId = saltId;
                parent.document.getElementById("iframeadd").contentWindow.loadData();
            }
        }
function delProduct(selectedIds)
{
    //删除前再次提醒是否真的要删除
    Ext.Msg.confirm("提示信息", "是否真的要删除选择的盐种信息吗？", function callBack(id) {
        //判断是否删除数据
        if (id == "yes") {
            var  qtSaltPGrid=Ext.getCmp('qtSaltProductGrid').getStore();
            //页面提交
            Ext.Ajax.request({
                url: 'frmSaltProductList.aspx?method=delSaltProduct',
                method: 'POST',
                params: {
                    ProductId: selectedIds,
                    SaltId:saltId
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {
                        qtSaltPGrid.reload();
                    }
                    qtSaltPGrid.reload();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "数据删除失败");
                }
            });
        }
    });
}
                       
                       
                               
/* 列表信息 */
var qtSaltProductStore = new Ext.data.Store
			({
                                           url: 'frmSaltProductList.aspx?method=getSaltProductList',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'SaltId' },
			    { name: 'SaltName' },
	            { name: 'ProductId' },
	            { name: 'ProductName' }
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
                   var qtSaltProductGrid = new Ext.grid.GridPanel({
                       el: 'qtSaltProduct_grid',
                       width: '100%',
                       height: '100%',
                       autoWidth: true,
                       autoHeight: true,
                       autoScroll: true,
                       layout: 'fit',
                       id: 'qtSaltProductGrid',
                       store: qtSaltProductStore,
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
                                            {header: 'SaltId', hidden: true, dataIndex: 'SaltId' },
									        //{ header: '公司名称', dataIndex: 'OrgName' },
									        { header: '盐品', dataIndex: 'SaltName' },
									        { header: 'ProductId', dataIndex: 'ProductId', hidden: true },
									        { header: '产品名称', dataIndex: 'ProductName' }
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
                   store: qtSaltProductStore,
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
           qtSaltProductGrid.render();
           
           function loadData()
           {
            
            qtSaltProductStore.reload();
           }
           qtSaltProductStore.baseParams.SaltId = saltId;
           qtSaltProductStore.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });
            
/**************设置具体盐种自己的等级***********************************/
//function setLevel()
//{
//    var selectData = qtSaltGrid.getSelectionModel().getCount();
//                           if (selectData == 0) {
//                               Ext.Msg.alert("提示", "请选中要要设置的产品信息！");
//                               return;
//                           }                           
//                           var record = qtSaltGrid.getSelectionModel().getSelections()[0].data;
//                           levelWindow.title=record.ProductName+"等级";
//                            selectedSaltId = record.SaltId;
//                              Ext.Ajax.request({
//                                url: 'frmQtSaltList.aspx?method=getTemplateItems',
//                                method: 'POST',
//                                params: {
//                                    ProductId: record.SaltId,
//                                    SaltId:saltId
//                                },
//                                success: function(resp, opts) {                                
//                                   var resu = Ext.decode(resp.responseText);
//                                   if(resu.success){
//                                       var item = Ext.decode(resu.errorinfo);
//                                        quotaItems=item.Quotas;
//                                        levelItems=item.Levels;
//                                        createLevelControl(levelItems,quotaItems);
//                                        setLevelFormValue();
//                                        if(!levelWindow.visible)
//                                            levelWindow.show();
//                                    }else{
//                                        Ext.Msg.alert("提示", "是否已经设置了检测标准");
//                                    }
//                                    
//                                },
//                                failure: function(resp, opts) {
//                                    Ext.Msg.alert("提示", "是否已经设置了检测标准");
//                                }
//                            });
//}

//var quotaItems=null;
//var levelItems=null;
//var levelForm = null;
//var selectedSaltId=0;
//var levelWindow;
//function createLevelControl(LevelItems,QuotaItems)
//{
//    levelWindow.removeAll();
//   levelCount = LevelItems.length;
//   var columnCount = levelCount+2;
//   levelForm = new Ext.Panel(
//   {
//	frame:true,
//	border:true,
//	layout:'table',
//	width:730,
//	height:'100%',
//	autoScroll:true,
//	layoutConfig:{columns:2}
//   });
//   
//   var leftForm =new Ext.Panel(
//   {
//	frame:true,
//	border:true,
//	layout:'table',
//	width:100,	
//	layoutConfig:{columns:1}
//   });
//   var rightForm =new Ext.Panel(
//   {
//	frame:true,
//	border:true,
//	layout:'table',
//	width:615,
//	
//	autoScroll:true,
//	layoutConfig:{columns:levelCount*2+2}
//   });
//   
//   for(var j=-1;j<QuotaItems.length;j++)
//   {
//        if(j==-1)
//        {
//            leftForm.add({ layout: 'table',width:150,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",html:'等级'}});
////            levelForm.add({ layout: 'table',width:80, layoutConfig: { columns: 1 },items:{xtype : "label",html:'等级'}});
//            for(var index=1;index<columnCount;index++)
//            {
//                var id = 0;
//                if(index-1<LevelItems.length)
//                {
//                    id=levelItems[index-1].LevelId;
//                }                
//               var txtLeveName=new Ext.form.TextField({ id: 'txtLeveName'+id,width:60 });
//               var txtLeave=new Ext.form.TextField({ id: 'txtLeve'+id ,width:20 });
//               var btnDel=new Ext.Button({id:'btnDel'+id,width:10,icon: '../Theme/1/images/extjs/customer/delete16.gif',listeners:{"click":function(){delLevel(this)}}});
//               var btnEdit=new Ext.Button({id:'btnEdt'+id,width:10,icon: '../Theme/1/images/extjs/customer/edit16.gif',listeners:{"click":function(){saveLevel(this)}}});
//               if(id==0)
//               {
//                    btnDel=new Ext.Button({id:'btnDel'+id,width:10,icon: '../Theme/1/images/extjs/customer/add16.gif',listeners:{"click":function(){saveLevel(this)}}});
//                    rightForm.add({ layout: 'table', layoutConfig: { columns: 5 },items:[{items:{xtype : "label",id:"lblLevelName"+id,width:50,html:'名称'}},{items:txtLeveName},{items:{xtype : "label",id:"lblLevel"+id,width:50,html:'级别'}},{items:txtLeave},{items:btnDel}]});
//               }
//               else
//               {
//                rightForm.add({ layout: 'table', layoutConfig: { columns: 6 },items:[{items:{xtype : "label",id:"lblLevelName"+id,width:50,html:'名称'}},{items:txtLeveName},{items:{xtype : "label",id:"lblLevel"+id,width:50,html:'级别'}},{items:txtLeave},{items:btnDel},{items:btnEdit}]});
//               }
//               var lblBoard = new Ext.form.Label({width:20,html:'&nbsp;'});
//               lblBoard.addClass("label-bord-class");
//               rightForm.add({ layout: 'table', layoutConfig: { columns: 1 },items:[{items:lblBoard}]});
////               levelForm.add({ layout: 'table', layoutConfig: { columns: 5 },items:[{items:{xtype : "label",width:50,html:'名称'}},{items:txtLeveName},{items:{xtype : "label",width:50,html:'级别'}},{items:txtLeave},{items:btnDel}]});
//            }
//            continue;
//        }
//        var item = QuotaItems[j];
//       for(var i=0;i<columnCount;i++)
//       {
//           //创建Label列
//	       if(i==0)
//           {
//                leftForm.add({ layout: 'table',valign:'bottom',width:150,height:22 ,layoutConfig: { columns: 1 },items:{xtype : "label",id : "lblQuotaName"+item.QuotaNo,html :item.QuotaName}});
////              levelForm.add({ layout: 'table',width:80, layoutConfig: { columns: 1 },items:{xtype : "label",id : "mylabel1",html :item.QuotaName}});
//	       }
//           else
//           {
//                var levelId = 0;
//                if(i>0 && i<columnCount-1)
//                {
//                    levelId = LevelItems[i-1].LevelId
//                }
//		        if(item.QuotaExt2=='Q102')//数值类型
//                {
//                    //添加Combox  >=(>= —)40 (<=,~,±,—)  <=80  
//                    var cmbLeft = new Ext.form.ComboBox({
//                         id: 'cmbLeft' +"L"+levelId.toString()+"Q"+ item.QuotaNo,
//                         store: leftStore, // 下拉数据           
//                         displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
//                         valueField:'id' , // 选项的值, 相当于option的value值        
//                         name: 'cmbLeft' +"L"+levelId.toString()+"Q"+ item.QuotaNo,
//                         mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
//                         triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
//                         readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
//                         emptyText: '请选择选择信息',
//                         width: 45,
//                         editable: false,
//                         selectOnFocus: true,
//                         listeners:{
//                            "blur":function()
//                            {
//                                var indexId = this.id.indexOf('Q');
//                                clearBlurLabelStyle(this.id.substring(indexId+1));
//                            },
//                            "focus":function(){
//                                    setLabelColor(this.id);                                
//                                }
//                         }
//                     });
//                    var cmbRight = new Ext.form.ComboBox({
//                         id: 'cmbRight'  +"L"+levelId.toString()+"Q"+ item.QuotaNo,
//                         store: rightStore, // 下拉数据           
//                         displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
//                         valueField:'id' , // 选项的值, 相当于option的value值        
//                         name: 'cmbRight'  +"L"+levelId.toString()+"Q"+ item.QuotaNo,
//                         mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
//                         triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
//                         readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
//                         emptyText: '请选择选择信息',
//                         width: 45,
//                         editable: false,
//                         selectOnFocus: true,
//                         listeners:{
//                            "blur":function()
//                            {
//                                var indexId = this.id.indexOf('Q');
//                                clearBlurLabelStyle(this.id.substring(indexId+1));
//                            },
//                            "focus":function(){setLabelColor(this.id);}
//                         }
//                     });
//                    var txtLeft=new Ext.form.TextField({ id: 'leftTxt'  +"L"+levelId.toString()+"Q"+ item.QuotaNo,width:40,listeners:{
//                            "blur":function()
//                            {
//                                var indexId = this.id.indexOf('Q');
//                                clearBlurLabelStyle(this.id.substring(indexId+1));
//                            },
//                            "focus":function(){setLabelColor(this.id);}
//                         } });
//                    var txtRight=new Ext.form.TextField({id:'rightTxt'+"L"+levelId.toString()+"Q"+ item.QuotaNo,width:40,listeners:{
//                            "blur":function()
//                            {
//                                var indexId = this.id.indexOf('Q');
//                                clearBlurLabelStyle(this.id.substring(indexId+1));
//                            },
//                            "focus":function(){setLabelColor(this.id);}
//                         }});
////                    levelForm.add({ layout: 'table', layoutConfig: { columns: 4 }, items: [{ items: cmbLeft }, { items: txtLeft},{items:cmbRight },{items:txtRight}] });
//                    rightForm.add({ layout: 'table', layoutConfig: { columns: 4 }, items: [{ items: cmbLeft }, { items: txtLeft},{items:cmbRight },{items:txtRight}] });
//                }
//                else
//                {
//                   var txtTextValue=new Ext.form.TextField({ id: 'textValue'  +"L"+levelId.toString()+"Q"+ item.QuotaNo,width:170,listeners:{
//                            "blur":function()
//                            {
//                                var indexId = this.id.indexOf('Q');
//                                clearBlurLabelStyle(this.id.substring(indexId+1));
//                            },
//                            "focus":function(){setLabelColor(this.id);}
//                         } });
////                   levelForm.add({ layout: 'table', layoutConfig: { columns: 1 }, items: [{items:txtTextValue}] });
//                   rightForm.add({ layout: 'table', layoutConfig: { columns: 1 }, items: [{items:txtTextValue}] });
//                }
//                var lblBoard = new Ext.form.Label({width:20,html:'&nbsp;'});
//               lblBoard.addClass("label-bord-class");
//               rightForm.add({ layout: 'table', layoutConfig: { columns: 1 },items:[{items:lblBoard}]});
//             }
//             
//       }
//       
//   }  
//   //宽度大于总体的宽度，需要添加滚动条，最右边需要添加空白行
//   if(178*(columnCount-1)>600)
//   {
//    leftForm.add({ layout: 'table',width:80,height:16 ,layoutConfig: { columns: 1 },items:{xtype : "label",id : "mylabel1",html :''}});
//   }   
//    levelForm.add(leftForm);
//    levelForm.add(rightForm);
//   levelWindow.add(levelForm);
//   
//   levelWindow.doLayout();


//}

//function setLabelColor(controlId)
//{
//    var indexId = controlId.indexOf('Q');
//    setCurrentLableStyle(controlId.substring(indexId+1));
//    var levelIndex = 0;
//    for(var i=indexId-1;i>0;i--)
//    {
//        if(controlId[i]=="L")
//        {
//            break;
//        }
//        levelIndex=i;
//    }
//    var levelId = controlId.substring(levelIndex,indexId);
//    setLevelLableStyle(levelId);
//}
//var currentLevel = -1;
//function setLevelLableStyle(levelId)
//{
//    if(currentLevel!=levelId)
//    {
//        Ext.getCmp('lblLevelName'+levelId).addClass('label-class');
//        Ext.getCmp('lblLevel'+levelId).addClass('label-class');
//        if(Ext.getCmp('lblLevelName'+currentLevel))
//        {
//            Ext.getCmp('lblLevelName'+currentLevel).removeClass('label-class');
//            Ext.getCmp('lblLevel'+currentLevel).removeClass('label-class');
//        }
//        currentLevel=levelId;
//    }
//}
//var currentIndex =0;
//function setCurrentLableStyle(labelId)
//{
//    if(currentIndex!=labelId)
//    {
//        Ext.getCmp('lblQuotaName'+labelId).addClass('label-class');
//        if(Ext.getCmp('lblQuotaName'+currentIndex))
//            Ext.getCmp('lblQuotaName'+currentIndex).removeClass('label-class');
//        currentIndex=labelId;
//    }
//    
//}
//function clearBlurLabelStyle(labelId)
//{
////    Ext.getCmp('lblQuotaName'+labelId).removeClass('label-class');
//}
 });
</script>
</head>
<body>
    <div id="qtSaltProduct_toolbar"></div>
    <div id="qtSaltProduct_grid"></div>
</body>
</html>
