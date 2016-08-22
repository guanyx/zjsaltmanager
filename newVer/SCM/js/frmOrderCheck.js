var dsWareHouse;
if (dsWareHouse == null) { //防止重复加载
	dsWareHouse = new Ext.data.Store
                ({
                	url: 'frmOrderCheck.aspx?method=getWarehouseList',
                	reader: new Ext.data.JsonReader({
                		totalProperty: 'totalProperty',
                		root: 'root'
                	}, [{ name: 'WhId' }, { name: 'WhName'}])
                });
}
var dsDlvType;
if (dsDlvType == null) { //防止重复加载
	dsDlvType = new Ext.data.Store
                ({
                	url: 'frmOrderCheck.aspx?method=getCommList',
                	reader: new Ext.data.JsonReader({
                		totalProperty: 'totalProperty',
                		root: 'root'
                	}, [{ name: 'DicsCode' }, { name: 'DicsName'}])
                });
}
var dsBillMode;
if (dsBillMode == null) { //防止重复加载
	dsBillMode = new Ext.data.Store
                ({
                	url: 'frmOrderCheck.aspx?method=getCommList',
                	reader: new Ext.data.JsonReader({
                		totalProperty: 'totalProperty',
                		root: 'root'
                	}, [{ name: 'DicsCode' }, { name: 'DicsName'}])
                });
}
var dsPayType;
if (dsPayType == null) { //防止重复加载
	dsPayType = new Ext.data.Store
                ({
                	url: 'frmOrderCheck.aspx?method=getCommList',
                	reader: new Ext.data.JsonReader({
                		totalProperty: 'totalProperty',
                		root: 'root'
                	}, [{ name: 'DicsCode' }, { name: 'DicsName'}])
                });
}
var dsDlvLevel;
if (dsDlvLevel == null) { //防止重复加载
	dsDlvLevel = new Ext.data.Store
                ({
                	url: 'frmOrderCheck.aspx?method=getCommList',
                	reader: new Ext.data.JsonReader({
                		totalProperty: 'totalProperty',
                		root: 'root'
                	}, [{ name: 'DicsCode' }, { name: 'DicsName'}])
                });
}
var dsOrderType;
if (dsOrderType == null) { //防止重复加载
	dsOrderType = new Ext.data.Store
                ({
                	url: 'frmOrderCheck.aspx?method=getCommList',
                	reader: new Ext.data.JsonReader({
                		totalProperty: 'totalProperty',
                		root: 'root'
                	}, [{ name: 'DicsCode' }, { name: 'DicsName'}])
                });
}    
dsWareHouse.load({ params: { start: 0, limit: 1234} });
dsDlvType.load({ params: { start: 0, limit: 1234, ParentsCode: 'S04'} });
dsBillMode.load({ params: { start: 0, limit: 1234, ParentsCode: 'S02'} });
dsPayType.load({ params: { start: 0, limit: 1234, ParentsCode: 'S03'} });
dsDlvLevel.load({ params: { start: 0, limit: 1234, ParentsCode: 'S05'} });
dsOrderType.load({ params: { start: 0, limit: 1234, ParentsCode: 'S01'} });