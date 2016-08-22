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
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;
using System.Text;
using System.IO;

public partial class SCM_frmAccidentInfoDocView : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //事故类型
        script.Append( "var dsAccidentType = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.SCM_ACCIDENT_TYPE ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
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
            case "getInfo":
                ZJSIG.UIProcess.SCM.UIScmAccidentInfo.getInfo( this );
                break;
            case "getInfoList":
                ZJSIG.UIProcess.SCM.UIScmAccidentInfo.getInfoList( this );
                break;
            case "getAccessories":
                download( Request.Params["fileName"] );
                break;
        }
    }

    /// <summary>
    /// 下载需要的文件
    /// </summary>
    /// <param name="fileName">客户端需要的文件名</param>
    private void download( string fileName )
    {
        string filePath = Request.PhysicalApplicationPath + CommonDefinition.ACCIDENT_FILE_UPLOAD_ROOT_PATH + fileName;//路径

        try
        {
            //以字符流的形式下载文件
            FileStream fs = new FileStream( filePath, FileMode.Open );
            byte[ ] bytes = new byte[ (int)fs.Length ];
            fs.Read( bytes, 0, bytes.Length );
            fs.Close( );
            Response.ContentType = "application/octet-stream";
            //通知浏览器下载文件而不是打开
            Response.AddHeader( "Content-Disposition", "attachment;  filename=" + HttpUtility.UrlEncode( fileName, System.Text.Encoding.Default ) );
            Response.BinaryWrite( bytes );
            Response.Flush( );
            Response.End( );
        }
        catch ( FileNotFoundException fnfe )
        {
            string errMsg = "您要查看的文件不存在";
            Response.Redirect( Request.ApplicationPath + "/errorPage.aspx" + "?errMessage=" + errMsg );
        }
        catch ( Exception ex )
        {
            string errMsg = "访问您要查看的文件时，出现异常：" + ex.Message;
            Response.Redirect( Request.ApplicationPath + "/errorPage.aspx" + "?errMessage=" + errMsg );
        }
    }
}
