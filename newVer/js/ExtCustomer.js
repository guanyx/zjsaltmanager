var viewport;
 
 var leftPanel = {
     region: 'west',
     id: 'west-panel',
     contentEl: 'LeftDiv',
     autoScroll: true,
     margins: '0 0 0 0',
     width: 200
}

var topPanel = {
    region: 'north',
    id: 'north-panel',
    contentEl: 'TopDiv',
    height: 75,
    margins: '0 0 0 0'
};

var bottomPanel = {
    region: 'south',
    id: 'south-panel',
    contentEl: 'BottomDiv',
    height: 20,
    margins: '0 0 0 0'
};

var contentPanel = {
    region: 'center',
    id: 'center-panel',
    contentEl: 'ContentDiv',
    layout: 'fit',
    margins: '0 0 0 0',
    border: false
};
