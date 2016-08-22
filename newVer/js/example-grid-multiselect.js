// some data used in the examples
Ext.namespace('Ext.exampledata');

Ext.exampledata.states = [
    ['AL', 'Alabama', 'The Heart of Dixie'],
    ['AK', 'Alaska', 'The Land of the Midnight Sun'],
    ['AZ', 'Arizona', 'The Grand Canyon State'],
    ['AR', 'Arkansas', 'The Natural State'],
    ['CA', 'California', 'The Golden State'],
    ['CO', 'Colorado', 'The Mountain State'],
    ['CT', 'Connecticut', 'The Constitution State'],
    ['DE', 'Delaware', 'The First State'],
    ['DC', 'District of Columbia', "The Nation's Capital"],
    ['FL', 'Florida', 'The Sunshine State'],
    ['GA', 'Georgia', 'The Peach State'],
    ['HI', 'Hawaii', 'The Aloha State']
];


Ext.namespace('Ext.example');
 

Ext.example.Store = new Ext.data.SimpleStore({
   	fields: ['id', 'name', 'title'],
    data : Ext.exampledata.states,

	/* needed to render in the grid... */
	getNamesByIds: function(keyString) { 
		if(keyString==undefined) return null;
		var keys = keyString.split(','); 
	   	var text  = ''; 
	   	for(var i=0; i<keys.length; i++)
		{  
	    	var item = Ext.example.Store.query('id', keys[i]).items[0]; 
	    	if(item != undefined) text += (text!='' ? '; ':'') + item.data['name']; 
	   	} 
    	return text;
	}
});


Ext.example.StateMultiSelect = function(config) {
    Ext.example.StateMultiSelect.superclass.constructor.call(this, config);
};
Ext.extend(Ext.example.StateMultiSelect, Ext.form.MultiSelectField, {
	store: Ext.example.Store 
	,valueField:'id'
	,displayField:'name'
	,mode: 'local'
});


 
var gridData = [
    ['3m Co',71.72,'AL'],
    ['Alcoa Inc',29.01,'AK'],
    ['Altria Group Inc',83.81,'AZ'],
    ['American Express Company',52.55,'AR'],
    ['American International Group, Inc.',0,'CA'],
    ['AT&T Inc.',31.61,'CO'],
    ['Boeing Co.',75.43,'CT'],
    ['Caterpillar Inc.',55,'DE'],
    ['Citigroup, Inc.',0,'DC'],
    ['E.I. du Pont de Nemours and Company',40.48,'FL'],
    ['Exxon Mobil Corp',68.1,'GA'] 
];

// create the data store
var gridStore = new Ext.data.SimpleStore({
    fields: [
       {name: 'company'},
       {name: 'price', type: 'float'},
       {name: 'state'},
    ]
});
gridStore.loadData(gridData);

// create the Grid
var grid = new Ext.grid.EditorGridPanel({
    store: gridStore,
    columns: [
        {id:'company',header: "Company", width: 160, sortable: true, dataIndex: 'company'},
        {header: "Price", width: 75, sortable: true, renderer: 'usMoney', dataIndex: 'price'},
		{header: "State", dataIndex:'state', width:200
			,editor: new Ext.example.StateMultiSelect({
				
			})
			,renderer: Ext.example.Store.getNamesByIds
		}
     ],
    stripeRows: true,
    autoExpandColumn: 'company',
    height:300,
    width:600,
    title:'Example Grid'
});
