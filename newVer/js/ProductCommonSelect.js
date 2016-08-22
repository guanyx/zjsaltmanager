/* 主要处理选择  */
var selectProductCommonGrid = null;
var selectProductCommonWin = null;
//设置文档目录信息，默认为1层信息
var productUrl="../BA/product/frmBaProduct.aspx?method=getProductInfoList";
function showProductCommonSelect( title,isPlan) {
    //构建form
    if (selectProductCommonGrid == null) {
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
                            productGridData.baseParams.MnemonicNo = Ext.getCmp('ProductNo').getValue();
                            productGridData.baseParams.ProductName = Ext.getCmp('ProductName').getValue();
                            productGridData.baseParams.IsPlan = isPlan;
                            productGridData.load({
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
        var productGridData = new Ext.data.Store
            ({
                url: productUrl,
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [
	            { name: 'ProductId'},
	            { name: 'ProductNo'},
	            { name: 'MnemonicNo'},
	            { name: 'SecurityCode'},
	            { name: 'ProductName'},
	            { name: 'AliasName'},
	            { name: 'Specifications'},
	            { name: 'SpecificationsText'},
	            { name: 'Unit'},
	            { name: 'StoreUnitId'},
	            { name: 'UnitText'},
	            { name: 'SupplierText'},
	            { name: 'IsPlan'},
	            { name: 'ProductType'}
	            ])	        
            });
        var sm= new Ext.grid.CheckboxSelectionModel({
	        singleSelect:true
        });
        selectProductCommonGrid = new Ext.grid.GridPanel({
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
	        store: productGridData,
	        loadMask: {msg:'正在加载数据，请稍侯……'},
	        sm:sm,
	        cm: new Ext.grid.ColumnModel([
		        sm,
		        new Ext.grid.RowNumberer(),//自动行号
		        {
			        header:'商品标识',
			        dataIndex:'ProdutctId',
			        id:'ProdutctId',
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
		        },
		        {
			        header:'存货规格',
			        dataIndex:'SpecificationsText',
			        id:'SpecificationsText',
			        hideable:false
		        },
		        {
			        header:'计量单位',
			        dataIndex:'UnitText',
			        id:'UnitText',
			        hideable:false
		        }]),
		        bbar: new Ext.PagingToolbar({
			        pageSize: 10,
			        store: productGridData,
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
    if (selectProductCommonWin == null || typeof (selectProductCommonWin) == "undefined") {//解决创建2个windows问题
        selectProductCommonWin = new Ext.Window({
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
		    , items: [searchForm,selectProductCommonGrid]
		    , buttons: [{
		        text: "确定"
		        ,id:'btnYes'
			    , handler: function() {
			        selectProductCommonWin.hide();
			    }
			    , scope: this
		    },
		    {
		        text: "取消"
			    , handler: function() {
			        selectProductCommonWin.hide();
			    }
			    , scope: this
            }]
        });
    }
    //显示
    selectProductCommonWin.show();
}