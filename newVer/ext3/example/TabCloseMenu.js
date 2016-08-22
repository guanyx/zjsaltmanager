/*!
 * Ext JS Library 3.0.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
/**
 * @class Ext.ux.TabCloseMenu
 * @extends Object 
 * Plugin (ptype = 'tabclosemenu') for adding a close context menu to tabs.
 * 
 * @ptype tabclosemenu
 */
Ext.ux.TabCloseMenu = function(){
    var tabs, menu, ctxItem;
    this.init = function(tp){
        tabs = tp;
        tabs.on('contextmenu', onContextMenu);
    };

    function onContextMenu(ts, item, e){
        if(item.title=='开始界面')
            return;
        if(!menu){ // create context menu on first right click
            menu = new Ext.menu.Menu({            
            items: [{
                id: tabs.id + '-close',
                text: '关闭菜单',
                icon: '../../Theme/1/images/tab/close.png',
                handler : function(){
                    if(ctxItem.title!='开始界面')
                    tabs.remove(ctxItem);
                }
            },{
                id: tabs.id + '-close-others',
                text: '关闭其它全部菜单',
                icon: '../../Theme/1/images/tab/close_other.png',
                handler : function(){
                    tabs.items.each(function(item){
                        if(item.closable && item != ctxItem){
                            if(item.title!='开始界面')
                            tabs.remove(item);
                        }
                    });
                }
            },{
                id: tabs.id + '-close-all',
                text: '关闭全部菜单',
                icon: '../../Theme/1/images/tab/close-all.png',
                handler : function(){
                    //tabs.removeAll();
                    tabs.items.each(function(item){
                        if(item.title!='开始界面')
                        tabs.remove(item);
                    });
                }
            }]});
        }
        ctxItem = item;
        var items = menu.items;
        items.get(tabs.id + '-close').setDisabled(!item.closable);
        var disableOthers = true;
        tabs.items.each(function(){
            if(this != item && this.closable){
                disableOthers = false;
                return false;
            }
        });
        items.get(tabs.id + '-close-others').setDisabled(disableOthers);
	
		var disableAll = true;
        tabs.items.each(function(){
            if(this.closable){
                disableAll = false;
                return false;
            }
        });
		items.get(tabs.id + '-close-all').setDisabled(disableAll);

		e.stopEvent();
        menu.showAt(e.getPoint());
    }
};

Ext.preg('tabclosemenu', Ext.ux.TabCloseMenu);
