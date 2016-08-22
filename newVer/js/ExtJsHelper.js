  /*ExtJs弹出式窗体的代码 */
//title：标题，url 要打开的窗体的Url地址,div输出到的div对象
function ExtJsShowWin(title,url,id,width,height)
{
      var win = new Ext.Window({
          title : title
          ,width: width
          ,height: height
          ,isTopContainer : true
          , constrain: true
	      ,closeAction:'hide'
	      , resizable: false
          ,modal : true
          ,resizable: false
          ,html:"<iframe id='iframe"+id+"' width='100%' height='100%' src='"+url+"'></iframe>"
          ,buttons: [{
	          text: "关闭"
		       ,handler: function() {
		            win.hide();
		    }
		 , scope: this
}]
       });
       return win;
}

var haveAddKeyDownEvent = false;
function AddKeyDownEvent(divName)
{
    if(haveAddKeyDownEvent==false)
    {
        haveAddKeyDownEvent = true;
        var all = Ext.query('input[type!=hidden][class!="x-tbar-page-number"]',divName); 
        Ext.each(all, function(o, i, all) { // 遍历并添加enter的监听 
            Ext.get(o).addKeyMap( { 
                key :13, 
                fn : function() { 
                try { 
                    all[i + 1].focus(); 
                } catch (error) { 
                    //event.keyCode = 9; 
                } 
                if (all[i + 1] && /button|reset|submit/.test(all[i + 1].type)) 
                    all[i + 1].click(); // 如果是按钮则触发click事件 
                return true; 
                } 
            }) 
            }); 
      }
  }

  function ColMolToXml(colModel) {
      var xml = "<?xml version=\"1.0\" standalone=\"yes\"?>";
      xml += "<NewDataSet>";
      for (var j = 0; j < colModel.config.length; j++) {
          if (colModel.config[j].hidden)
              continue;
          if (colModel.config[j].header == null)
              continue;
          if (colModel.config[j].header.indexOf("<div") != -1)
              continue;
          xml += "<Table>";
          xml += "<width>" + colModel.config[j].width + "</width>";
          xml += "<dataIndex>" + colModel.config[j].dataIndex + "</dataIndex>";
          xml += "<header>" + colModel.config[j].header + "</header>";
          xml += "</Table>";
      }
      xml += "</NewDataSet>";
      return xml;
  }
  
  function GroupToXml(groupModel){
    var xml = "<?xml version=\"1.0\" standalone=\"yes\"?>";
      xml += "<NewDataSet>";
      for (var j = 0; j < groupModel.config.rows[0].length; j++) {
          xml += "<Table>";
          if(groupModel.config.rows[0][j].header!=null)
          {
            xml += "<header>" + groupModel.config.rows[0][j].header + "</header>";
          }
          xml += "<colspan>" +  groupModel.config.rows[0][j].colspan + "</colspan>";
          
          xml += "</Table>";
      }
      xml += "</NewDataSet>";
      return xml;
  }

  function JsonToXml(jsonData, colModel) {
      var xml = "<?xml version=\"1.0\" standalone=\"yes\"?>";
      xml += "<NewDataSet>";
      for (var i = 0; i < jsonData.data.items.length; i++) {
          xml += "<Table>";

          for (var j = 0; j < colModel.config.length; j++) {
//              if (colModel.config[j].hidden)
//                  continue;
              if (colModel.config[j].header == null)
                  continue;
              if (colModel.config[j].header.indexOf("<div") != -1)
                  continue;
              if (colModel.config[j].header != "") {
                  xml += "<" + colModel.config[j].dataIndex + ">" + jsonData.data.items[i].get(colModel.config[j].dataIndex) + "</" + colModel.config[j].dataIndex + ">";
              }
          }
          xml += "</Table>";
      }
      xml += "</NewDataSet>";
      return xml;
  }

  var printGrid = null;
  var printGridData = null;
  var printTitle = '';

  function createPrintButton(tempGridData, tempGrid,printIco) {
      printGrid = tempGrid;
      printGridData = tempGridData;
      if (printIco == "") {
          printIco = "printico";
      }
      var printButton = new Ext.Button({
          id: 'printButton',
          iconCls: printIco
      });
      printButton.on("click", PrintList);
      return printButton;
  }
  function PrintList() {
      var printControl = parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
      //                    printControl.PrintXml = printData;
      printControl.OnePageNum = 1;
      printControl.GridData = JsonToXml(printGridData, printGrid.colModel);
      printControl.GridStyle = ColMolToXml(printGrid.colModel);
      printControl.GridTitle = printTitle;
      printControl.PrintGrid();
  }