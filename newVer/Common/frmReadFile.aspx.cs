using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.IO;

public partial class Common_frmReadFile : PageBase 
{

    /// <summary>
    /// 获取文件路径
    /// </summary>
    public string Path
    {
        get
        {
            string _path = System.Configuration.ConfigurationSettings.AppSettings[ "UploadFilePath" ];
            if ( _path.IndexOf( ":" ) != -1 )
                return _path;
            else
                return Server.MapPath( "~/"+_path);
        }
    }

    /// <summary>
    /// 获取文件类型
    /// </summary>
    public string FileType
    {
        get
        {
            return Server.UrlDecode( this.Request[ "filetype" ] );
        }
    }

    /// <summary>
    /// 获取文件名称
    /// </summary>
    public string FileName
    {
        get
        {
            return Server.UrlDecode( this.Request[ "FileName" ] );
        }
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        doGetAttachData( );
    }

    //protected string deleteFile( )
    //{
    //    string filePath = "";
    //    switch ( FileType.ToLower( ) )
    //    {
    //        //证书结论
    //        case "zsjl":
    //            filePath = Path + "\\zsjl\\" + FileName + ".doc";
    //            if ( !haveFile( filePath ) )
    //            {
    //                return "nofile";
    //            }
    //            break;
    //        case "zs":
    //            filePath = Path + "\\zs\\" + FileName + ".doc";
    //            if ( !haveFile( filePath ) )
    //            {
    //                return "nofile";
    //            }
    //            break;
    //    }
    //    FileInfo f = new FileInfo( filePath );
    //    try
    //    {
    //        f.Delete( );
    //        return "true";
    //    }
    //    catch
    //    {
    //        return "false";
    //    }

    //}
    /// <summary>
    /// 从数据库或者磁盘中读取文件并发送给客户端,文件名可以不附带后缀
    /// 但是不带后缀的只取找到相同文件名的第一个文件
    /// </summary>
    public void doGetAttachData( )
    {
        string filePath = Path + "\\" + FileType + "\\";
        //filePath =  + FileName;

        
        //if (filePath == "")
        //    return;
        filePath = checkFile( filePath,FileName );
        if ( filePath == "" )
            return;
        using ( FileStream s = new FileStream( filePath, FileMode.Open ) )
        {

            byte[ ] buffer = new byte[ Convert.ToInt32( s.Length ) ];
            s.Read( buffer, 0, buffer.Length );
            Response.BinaryWrite( buffer );
        }
        this.Response.End( );
    }

    //private byte[ ] getBuffer( string filePath )
    //{
    //    DataSet ds = Application[ "FileData" ] as DataSet;
    //    if ( ds == null )
    //    {
    //        ds = new DataSet( );
    //        DataTable dt = new DataTable( );
    //        dt.Columns.Add( "filePath" );
    //        dt.Columns.Add( "BufferData", typeof( byte[ ] ) );
    //        ds.Tables.Add( dt );
    //    }
    //    DataRow[ ] dr = ds.Tables[ 0 ].Select( "FilePath = '" + filePath + "'" );
    //    if ( dr.Length == 0 )
    //    {
    //        using ( FileStream s = new FileStream( filePath, FileMode.Open ) )
    //        {


    //            byte[ ] buffer = new byte[ Convert.ToInt32( s.Length ) ];
    //            s.Read( buffer, 0, buffer.Length );
    //            DataRow drNew = ds.Tables[ 0 ].NewRow( );
    //            drNew[ "filePath" ] = filePath;
    //            drNew[ "BufferData" ] = buffer;
    //            ds.Tables[ 0 ].Rows.Add( drNew );
    //            this.Application[ "FileData" ] = ds;
    //            return buffer;
    //            //Cache.Insert("","",new System.Web.Caching.CacheDependency(Server.MapPath()),

    //        }
    //    }
    //    else
    //    {
    //        return (byte[ ])dr[ 0 ][ "BufferData" ];
    //    }

    //}

    //private void downLoadFile( string fileName )
    //{
    //    string realFileName = fileName.Substring( fileName.LastIndexOf( "\\" ) + 1 );
    //    this.Response.Buffer = true;
    //    this.Response.Clear( );
    //    this.Response.ContentType = "application/octet-stream";
    //    this.Response.AddHeader( "Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode( realFileName ) );

    //    FileStream s = new FileStream( fileName, FileMode.Open );
    //    try
    //    {

    //        byte[ ] buffer = new byte[ Convert.ToInt32( s.Length ) ];
    //        s.Read( buffer, 0, buffer.Length );
    //        Response.BinaryWrite( buffer );
    //    }
    //    catch
    //    {
    //    }
    //    finally
    //    {
    //        s.Close( );
    //    }
    //    this.Response.Flush( );
    //    this.Response.End( );

    //}
    private string checkFile( string path,string fileName )
    {
        string[] files=null;
        if ( FileName.IndexOf( "." ) != -1 )
        {
            files = System.IO.Directory.GetFiles( path, FileName );
        }
        else
        {
            files = System.IO.Directory.GetFiles( path, FileName + ".*" );
        }
        if ( files.Length > 0 )
            return files[ 0 ];
        return "";
    }

    /// <summary>
    /// 根据文件名称，以及路径，获取文件全名，如果不存在就返回空字符串
    /// </summary>
    /// <param name="filePath"></param>
    /// <returns></returns>
    public string getFileName( string filePath, string fileName )
    {
        string path = Server.MapPath( "~/upload" );
        if(fileName.IndexOf('.')==-1)
        {
            fileName=fileName + ".*";
        }
        string[ ] files = System.IO.Directory.GetFiles( path + "\\" + filePath, fileName );
        path = path + "\\" + filePath + "\\" + fileName + ".";
        foreach ( string str in files )
        {
            if ( str.IndexOf( path ) != -1 )
                return str;
        }
        return "";
    }
}
