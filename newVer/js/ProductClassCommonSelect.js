/* 主要处理选择  */
var selectProductClassCommonGrid = null;
var selectProductClassCommonWin = null;
//设置文档目录信息，默认为1层信息
var productClassUrl="../CRM/product/frmBaProductClass.aspx?method=getClassProducts";
function showProductClassCommonSelect( title,isPlan) {
    //构建form
    if (selectProductClassCommonGrid == null) {
        var searchForm =  new Ext.form.FormPanel({
            labelAlign: 'left',
            //layout:'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:2px',
            frame: true,
            height: 40,
            labelWidth: 60,
            region: 'north',//定位
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .25,
                    layout: 'form',
                    border: false,
                    items: [{ 
			            xtype:'textfield',
			            fieldLabel:'存货编号',
			            anchor:'90%',
			            name:'ProductNo',
			            id:'ProductNo'
			         }]
		        },{
                    columnWidth: .25,
                    layout: 'form',
                    border: false,
                    items: [{ 
			            xtype:'textfield',
			            fieldLabel:'存货名称',
			            anchor:'90%',
			            name:'ProductName',
			            id:'ProductName'
			         }]
		        },{
                    columnWidth: .08,
                    layout: 'form',
                    border: false,
                    items: [{ 
                        cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        anchor: '50%',
                        handler :function(){
                            productTypGridData.baseParams.ProductNo = Ext.getCmp('ProductNo').getValue();
                            productTypGridData.baseParams.ProductName = Ext.getCmp('ProductName').getValue();
                            productTypGridData.load({
                                params: {
                                    start: 0,
                                    limit: defaultPageSize
                                }
                            });
                        }
                    }]
                }]
            }]
        });
        var productTypGridData = new Ext.data.Store
            ({
                url: productClassUrl,
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [
	            { name: 'ProductId'},
	            { name: 'ProductNo'},
	            { name: 'ProductName'},
	            { name: 'ClassId'},
	            { name: 'ClassNo'},
	            { name: 'ClassName'}
	            ])	        
            });
        var sm= new Ext.grid.CheckboxSelectionModel({
	        singleSelect:true
        });
        selectProductClassCommonGrid = new Ext.grid.GridPanel({
	        //el: 'dataGrid',
	        region: 'center',            
            viewConfig : {
                forceFit : true
            },
            width: 300,
            height:100,
	        autoScroll:true,
	        //layout: 'fit',
	        id: '',
	        store: productTypGridData,
	        loadMask: {msg:'正在加载数据，请稍侯……'},
	        sm:sm,
	        cm: new Ext.grid.ColumnModel([
		        sm,
		        new Ext.grid.RowNumberer(),//自动行号
		        {
			        header:'商品标识',
			        dataIndex:'ClassId',
			        id:'ProductId',
			        hidden:true,
			        hideable:false
		        },
		        {
			        header:'存货编号',
			        dataIndex:'ProductNo',
			        id:'ProductNo',
			        hideable:false
		        },
		        {
			        header:'存货名称',
			        dataIndex:'ProductName',
			        id:'ProductName',
			        hideable:false
		        }]),
		        bbar: new Ext.PagingToolbar({
			        pageSize: 10,
			        store: productTypGridData,
			        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			        emptyMsy: '没有记录',
			        displayInfo: true
		        }),
		        enableHdMenu: false,  //不显示排序字段和显示的列下拉框
		        enableColumnMove: false,//列不能移动
		        closeAction: 'hide',
		        stripeRows: true,
		        loadMask: true,
		        autoExpandColumn: 2
	        });
    }
    
    //构建window
    if (selectProductClassCommonWin == null || typeof (selectProductClassCommonWin) == "undefined") {//解决创建2个windows问题
        selectProductClassCommonWin = new Ext.Window({
              id: 'selectProductCommonForm'
            , title: title
		    , iconCls: 'upload-win'
		    , width: 650
		    , height: 400
		    , layout: 'border'
		    , plain: true
		    , modal: true
		    , x: 100
		    , y: 100
		    , constrain: true
		    , resizable: false
		    , closeAction: 'hide'
		    , autoDestroy: true
		    , items: [searchForm,selectProductClassCommonGrid]
		    , buttons: [{
		        text: "确定"
		        ,id:'btnYes'
			    , handler: function() {
			        selectProductClassCommonWin.hide();
			    }
			    , scope: this
		    },
		    {
		        text: "取消"
			    , handler: function() {
			        selectProductClassCommonWin.hide();
			    }
			    , scope: this
            }]
        });
    }
    //显示
    selectProductClassCommonWin.show();
}