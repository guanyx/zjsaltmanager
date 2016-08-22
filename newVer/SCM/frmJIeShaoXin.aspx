<html>
<head><title>DsoFramer Control Test Page (KB311765)</title>
<script src="../js/officeoperator.js" ></script>
<style>
.fontSize1 {font-size: 65%; 	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;}
.fontSize2 {font-size: 70%; 	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;}
.fontSize3 {font-size: 75%; 	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;}
.fontSize4 {font-size: 80%; 	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;}
.fontSize5 {font-size: 125%; 	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;}

.fakehlink {cursor: hand; text-decoration: underline; color: #0066CC; font-weight:normal;}

</style>

</head>
<body bgcolor="#ffffff" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">


<!--titlebar start-->


<!--titlebar end-->

<!--main body start-->
<div class="fakehlink" onClick="openurlfile();">openFileUrl</div><br>
        <div class="fakehlink" onClick="setBookMarkValue();">setBookMark</div><br>
        <div class="fakehlink" onClick="showBookMarks();">setBookMark</div><br>

<!--left-side start-->

  
<!--right-side start-->

  <table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
     <td valign="top"></td>
     <td valign="top" colspan="2">
       <object classid="clsid:00460182-9E5E-11d5-B7C8-B8269041DD57" id="oframe" codebase="dsoframer.ocx" width="100%" height="100%">
         <param name="BorderStyle" value="1">
         <param name="TitlebarColor" value="52479">
         <param name="TitlebarTextColor" value="0">
         <param name="Menubar" value="1"> 
       </object>
     </td>
    </tr>
    <tr>
     <td valign="top" height="15"></td>
     <td valign="bottom" class="fontSize1" colspan="2">Copyright (c)2001-2004 Microsoft Corporation. All rights reserved.</td>
    </tr>
  </table>

<!--right-side end-->

<script type="text/javascript">
DosFrame = document.all.oframe;
DosFrame.EventsEnabled =true;
//DosFrame.Titlebar = false;
//DosFrame.Toolbars = false;
//DosFrame.Menubar = false;
DosFrame.focus();//=true;
//DosFrame.ActivationPolicy = DosFrame.dsoActivationPolicy.dsoKeepUIActiveOnAppDeactive;
function setBookMarkValue()
{
    setBookMarksValue("编号","11111");
    var table = GetTableByBookMark("测试1");
    var index = table.Rows.Count;
    for(var i=0;i<100;i++)
    {
        AddCurrentIndexRow(table,table.Rows.Count-1);
    }
    for(var i=0;i<100;i++)
    {
        for(var j=1;j<4;j++)
        {
            var row = table.Rows(index+i);
            row.Cells.Item(j).Range.Text=i+":"+j;
        }
    }
    SetReadOnly(true);
    //document.all.oframe.ActiveDocument.BookMarks("编号").Range.Text="1212";//SetFieldValue("编号","121212","");
    //document.getElementById("oframe").setFieldValue("编号","121212","");
}

function openurlfile()
{
    if(typeof(document.all.oframe)=='undefined')
    { 
        setTimeout('openurlfile()', 1000);
        return;
    }
   
   try
   {
//document.getElementById("oframe").CreateNew("Word.Document");
    document.getElementById("oframe").open("http://172.18.2.122/zjsigsite/Common/frmReadFile.aspx?filetype=test&filename=test3",true);
    
    }
    catch(Error)
    {
        setTimeout('openurlfile()', 1000);
        return;
    }
    //setBookMarkValue();
}
function showBookMarks()
{
    alert(oframe.ActiveDocument.BookMarks.length);
}
//openurlfile();

</script>
<!--main body end-->

</body>
</html>