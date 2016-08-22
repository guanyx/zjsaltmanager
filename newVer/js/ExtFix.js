/*fix datefield width bug*/
Ext.override(Ext.menu.DateMenu,{
 render : function(){
  Ext.menu.DateMenu.superclass.render.call(this);
  if(Ext.isChrome||Ext.isGecko|| Ext.isSafari||Ext.isWebKit||Ext.isGecko2||Ext.isGecko3|| Ext.isSafari2|| Ext.isSafari3){
   this.picker.el.dom.childNodes[0].style.width = '178px';
   this.picker.el.dom.style.width = '178px';
  }
 }
});