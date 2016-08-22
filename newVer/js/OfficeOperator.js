
//控件对象
var DosFrame;

//获取含有指定书签的Table
function GetTableByBookMark(bookName)
{
    return DosFrame.ActiveDocument.BookMarks(bookName).Range.Tables(1);
}

function CopyStart()
{
    var start = DosFrame.ActiveDocument.Content.Start;
    var end = DosFrame.ActiveDocument.Content.End;
    var rang =  DosFrame.ActiveDocument.Range(start,end);
    rang.Copy();
}

function PastEnd()
{
    var end = DosFrame.ActiveDocument.Content.End;
    var rang =  DosFrame.ActiveDocument.Range(end-1,end);
    rang.Paste();
}

function InsertFile(url)
{
    var end = DosFrame.ActiveDocument.Content.End;
    var rang =  DosFrame.ActiveDocument.Range(end-1,end);
    rang.InsertFile(url,'', false, true, false); 
}
//插入下一页，页码重新开始
function InsertNextPageBreak()
{
    var end = DosFrame.ActiveDocument.Content.End;
    var rang =  DosFrame.ActiveDocument.Range(end-1,end);
    rang.Select();
    DosFrame.ActiveDocument.Application.Selection.InsertBreak(2);
}

//在当前表中添加新的行
function AddCurrentIndexRow(table,currentIndex)
{
    var row = table.Rows(currentIndex);
    table.Rows.Add(row);
}

//设置书签内容
function setBookMarksValue(bookName,bookMarkValue)
{
    if(DosFrame.ActiveDocument.BookMarks.Exists(bookName))
    {
        range = DosFrame.ActiveDocument.BookMarks(bookName).Range
        range.Text=bookMarkValue;
    }
}

function SetReadOnly(boolvalue)
{
    var i;
	try
	{
		if(boolvalue)
		{
		     DosFrame.ActiveDocument.Protect(2,true,"");
		}
		else
		{
		    DosFrame.ActiveDocument.Unprotect();
		}
	}
	catch(err){
		alert("错误：" + err.number + ":" + err.description);
	}
	finally{}
}