var HTMLEditor = Ext.extend(Ext.form.HtmlEditor, {
addImage : function() {
   var editor = this;
   var imgform = new Ext.FormPanel({
    region : 'center',
    labelWidth : 55,
    frame : true,
    bodyStyle : 'padding:5px 5px 0',
    autoScroll : true,
    border : false,
    fileUpload : true,
    items : [{
       xtype : 'textfield',
       fieldLabel : 'ѡ���ļ�',
       name : 'userfile',
       id : 'userfile',
       inputType : 'file',
       allowBlank : false,
       blankText : '�ļ�����Ϊ��',
       height : 25,
       anchor : '98%'
      }],
    buttons : [{
     text : '�ϴ�',
     type : 'submit',
     handler : function() {
      var furl="";
      furl=imgform.form.findField('userfile').getValue();
      var type=furl.substring(furl.length-3).toLowerCase();
      if (furl==""||furl==null) {return;}
      if(type!='jpg'&&type!='bmp'&&type!='gif'&&type!='png'){
       alert('��֧��jpg��bmp��gif��png��ʽ��ͼƬ');
       return;
      }
      imgform.form.submit({
       url : '/Common/frmUpLoadFile.aspx?method=addFileInNews&fu='+furl,
       waitMsg : '�����ϴ�......',
       waitTitle : '��ȴ�',
       method : 'POST',
       success : function(form, action) {
        var element = document.createElement("img");
        element.src = action.result.fileURL;
        if (Ext.isIE) {
         editor.insertAtCursor(element.outerHTML);
        } else {
         var selection = editor.win.getSelection();
         if (!selection.isCollapsed) {
          selection.deleteFromDocument();
         }
         selection.getRangeAt(0).insertNode(element);
        }
        form.reset();
        win.close();
       },
       failure : function(form, action) {
        form.reset();
        if (action.failureType == Ext.form.Action.SERVER_INVALID)
         Ext.MessageBox.alert('����',
           '�ϴ�ʧ�ܣ���֧��jpg��bmp��gif��png��ʽ��ͼƬ');
       
       }
      
      });
     }
    }, {
     text : '�ر�',
     type : 'submit',
     handler : function() {
      win.close(this);
     }
    }]
   })
   var win = new Ext.Window({
      title : "�ϴ�ͼƬ",
      id : 'picwin',
      width : 400,
      height : 150,
      modal : true,
      border : false,
     
      layout : "fit",
      items : imgform
     });
   win.show();
  
},
addFile : function() {
   var editor = this;
   var fileform = new Ext.FormPanel({
    region : 'center',
    labelWidth : 55,
    frame : true,
    bodyStyle : 'padding:5px 5px 0',
    autoScroll : true,
    border : false,
    fileUpload : true,
    items : [{
       xtype : 'textfield',
       fieldLabel : 'ѡ���ļ�',
       name : 'userfile',
       id : 'userfile',
       inputType : 'file',
       allowBlank : false,
       blankText : '�ļ�����Ϊ��',
       height : 25,
       anchor : '98%'
      }],
    buttons : [{
     text : '�ϴ�',
     type : 'submit',
     handler : function() {
      var furl="";//�ļ������ַ
      var fname="";//�ļ�����
      furl=fileform.form.findField('userfile').getValue();
      var type=furl.substring(furl.length-3).toLowerCase();
      if (furl==""||furl==null) {return;}
      if(type!='doc'&&type!='xls'){
       alert('��֧���ϴ�doc��xls��ʽ���ļ�!');
       return;
      }
      fname=furl.substring(furl.lastIndexOf("\\")+1);
      fileform.form.submit({
       url : '/Common/frmUpLoadFile.aspx?method=addFileInNews&fu='+furl,
       waitMsg : '�����ϴ�......',
       waitTitle : '��ȴ�',
       method : 'POST',
       success : function(form, action) {
        var element = document.createElement("a");
        element.href = action.result.fileURL;
        element.target = '_blank';
        element.innerHTML = fname;
        if (Ext.isIE) {
         editor.insertAtCursor(element.outerHTML);
        } else {
         var selection = editor.win.getSelection();
         if (!selection.isCollapsed) {
          selection.deleteFromDocument();
         }
         selection.getRangeAt(0).insertNode(element);
        }
        form.reset();
        winFile.close();
       },
       failure : function(form, action) {
        form.reset();
        if (action.failureType == Ext.form.Action.SERVER_INVALID)
         Ext.MessageBox.alert('����',
           '�ϴ�ʧ�ܣ���֧���ϴ�doc��xls��ʽ���ļ�!');
       
       }
      
      });
     }
    }, {
     text : '�ر�',
     type : 'submit',
     handler : function() {
      winFile.close(this);
     }
    }]
   })
   var winFile = new Ext.Window({
      title : "�ϴ�����",
      id : 'picwin',
      width : 400,
      height : 150,
      modal : true,
      border : false,
     
      layout : "fit",
      items : fileform
     });
   winFile.show();
  
},
createToolbar : function(editor) {
   HTMLEditor.superclass.createToolbar.call(this, editor);
   this.tb.insertButton(16, {
      cls : "x-btn-icon",
      icon : "/Theme/1/images/extjs/customer/s_add.gif",
      handler : this.addImage,
      scope : this
     });
   this.tb.insertButton(17, {
      cls : "x-btn-icon",
      icon : "/Theme/1/images/extjs/customer/doc.png",
      handler : this.addFile,
      scope : this
     });
}
});
Ext.reg('starthtmleditor', HTMLEditor);
