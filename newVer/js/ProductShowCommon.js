
//定义产品下拉框异步调用方法
var dsProducts;
var getProductUrl = '';
//定义输入的Text文本框
var productText = new Ext.form.TextField({
            name:"ProductNameTpl",
            id:"ProductNameTpl"});
            
//定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductUnits ;
        
        //计量单位下拉框
        var UnitCombo;
        
//定义产品下拉框的数据格式
function createProductList()
{
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: getProductUrl+'?method=getProductByNameNo',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty'
                    }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'SalePrice', mapping: 'SalePrice' },
                            { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                            { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' }
                        ])
                });
                
                dsProductUnits = new Ext.data.Store({   
                    url:getProductUrl+ '?method=getProductUnits',  
                    params: {
                        ProductId:0
                    },
                    reader: new Ext.data.JsonReader({  
                        root: 'root',  
                        totalProperty: 'totalProperty',  
                        id: 'ProductUnits'  
                    }, [  
                        {name: 'UnitId', mapping: 'UnitId'}, 
                        {name: 'UnitName', mapping: 'UnitName'}
                    ]) 
                }); 
                
                UnitCombo = new Ext.form.ComboBox({
                    store: dsProductUnits,
                    displayField: 'UnitName',
                    valueField: 'UnitId',
                    triggerAction: 'all',
                    id: 'UnitCombo',
                    //pageSize: 5,  
                    //minChars: 2,  
                    //hideTrigger: true,  
                    typeAhead: true,
                    mode: 'local',
                    emptyText: '',
                    selectOnFocus: false,
                    editable: false
                });
            }  
}
        
//添加事件
        productText.on("focus",setProductFilter);

//定义产品下拉框
        var productFilterCombo=null;
        
        // 定义下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>编号:{ProductNo}&nbsp;  名称:{ProductName}</span></h3>',
            '</div></tpl>'  
        ); 
        
        function setProductFilter()
        {
            //setProductFilter();
            //dsProducts.baseParams.CustomerId=Ext.getCmp("CustomerId").getValue();
            if(productFilterCombo==null)
            {
                productFilterCombo = new Ext.form.ComboBox({
                store: dsProducts,
                displayField: 'ProductName',
                displayValue: 'ProductId',
                typeAhead: false,
                minChars: 1,
                width:300,
                loadingText: 'Searching...',
                tpl: resultTpl,  
                itemSelector: 'div.search-item',  
                pageSize: 10,
                hideTrigger: true,
                applyTo: 'ProductNameTpl',
                onSelect: function(record) { // override default onSelect to do redirect  
                      selectedEvent(record);           
                }
            });
            }
        }
        
        
    function beforeEdit(e)
    {
                    var record = e.record;
                    if(record.data.ProductId != dsProductUnits.baseParams.ProductId)
                    {
                        dsProductUnits.baseParams.ProductId = record.data.ProductId;
                        dsProductUnits.load();
                    }
    }
    
    function getUnitName(value,dsUnits)
    {
        var index = dsUnits.findBy(function(record, id) {  
	                return record.get(UnitCombo.valueField)==value; 
                });
                var record = dsUnits.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.UnitName; //获取record中的数据集中的process_name字段的值
                }
                return displayText;
    }