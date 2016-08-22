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
using System.Xml.Linq;
using System.IO;

public partial class SCM_test :PageBase
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
                return Server.MapPath( "~/" + _path );
        }
    }

    protected void Page_Load( object sender, EventArgs e )
    {
         string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch ( Exception ex )
        {
        }

        switch ( method )
        {
            case "exportInvoice"://合同类型下拉框
                downloadFromDisk( );
                break;
            case "importInvoice":
                SaveFiles( );
                break;
        }        
    }

    /// <summary>
    /// 上传文件
    /// </summary>
    /// <returns></returns>
    public void SaveFiles( )
    {
        ///'遍历File表单元素  
        HttpFileCollection files = Request.Files;

        try
        {
            for ( int iFile = 0; iFile < files.Count; iFile++ )
            {
                //检查文件扩展名字  
                HttpPostedFile postedFile = files[ iFile ];
                string fileName, fileExtension;
                fileName = System.IO.Path.GetFileName( postedFile.FileName );
                if ( fileName != "" )
                {
                    string fileName_Prifix = ZJSIG.UIProcess.ADM.UIAdmUser.OrgID( this ) + "_" + DateTime.Now.ToString( "yyyyMMddHHmmss" ) + "_";
                    ///注意：可能要修改你的文件夹的匿名写入权限。  
                    postedFile.SaveAs( Path + "\\invoice_files\\import_files\\" + fileName_Prifix+fileName );
                    //+ CommonDefinition.CONTRACT_FILE_UPLOAD_ROOT_PATH + DateTime.Now.ToString( "yyyyMMddHHmmsss" ) + "_" + fileName );

                    //调用解析文件逻辑
                    //拆分行记录后，保存到表呀什么的
                }
            }
            Response.Write( "{\"success\":\"true\"}" );
            Response.End( );
        }
        catch ( System.Exception Ex )
        { 
            
        }
    }

    public void downloadFromDisk( )
    {
        string fileName = ZJSIG.UIProcess.ADM.UIAdmUser.OrgID( this ) + "_" + DateTime.Now.ToString( "yyyyMMddHHmmss" ) + ".txt";
        string filePath = Path + "\\invoice_files\\export_files\\" + fileName;
        using ( StreamWriter sw = File.CreateText( filePath ) )
        {
            //调用生成文件逻辑
            //组装主记录呀明细呀什么的
            sw.WriteLine( "This is my file." );
            sw.WriteLine( "I can write ints {0} or floats {1}, and so on.",
                1, 4.2 );
            sw.Close( );

            FileStream fs = new FileStream( filePath, FileMode.Open );
            byte[ ] bytes = new byte[ (int)fs.Length ];
            fs.Read( bytes, 0, bytes.Length );
            fs.Close( );
            Response.ContentType = "application/octet-stream";
            //通知浏览器下载文件而不是打开
            Response.AddHeader( "Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode( fileName, System.Text.Encoding.Default ) );
            Response.BinaryWrite( bytes );
            Response.Flush( );
        }
        this.Response.End( );
    }
}
