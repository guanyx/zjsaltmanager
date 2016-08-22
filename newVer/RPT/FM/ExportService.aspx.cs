using System;
using System.Collections;
using System.Collections.Specialized;
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
using System.Text;
using System.IO;

public partial class RPT_FM_ExportService : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request["ExportContent"] != "")
            {
                if ( Request[ "ExportGroup" ] != null )
                {
                    ExportFile( );
                    return;
                }
                string tmpFileName = "export.xls";
                string tmpContent = Request["ExportContent"];//获取传递上来的文件内容  
                if (Request["ExportFile"] != "")
                {
                    tmpFileName = Request["ExportFile"];//获取传递上来的文件名  
                    //tmpFileName = System.Web.HttpUtility.UrlEncode(Request.ContentEncoding.GetBytes(tmpFileName));//处理中文文件名的情况   
                }

                Response.Write("&amp;lt;script&amp;gt;document.close();&amp;lt;/script&amp;gt;");
                Response.Clear();
                Response.Buffer = true;
                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", "attachment;filename=\"" + tmpFileName + "\"");
                Response.Charset = "";

                this.EnableViewState = false;
                System.IO.StringWriter tmpSW = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter tmpHTW = new System.Web.UI.HtmlTextWriter(tmpSW);
                tmpHTW.WriteLine(tmpContent);
                Response.Write(tmpSW.ToString());
                Response.End();

            }
        } 
    }

    private void ExportFile( )
    {
        System.Collections.Specialized.NameValueCollection gb2312 = HttpUtility.ParseQueryString( Request["ExportContent"], System.Text.Encoding.GetEncoding( "utf-8" ) );

        string strdata = Server.UrlDecode( gb2312[0] );
        strdata = strdata.Replace( "$", "_" );
        System.IO.StringReader objReader = new System.IO.StringReader( strdata );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        objReader.Close( );
        gb2312 = HttpUtility.ParseQueryString( Request[ "ExportGroup" ], System.Text.Encoding.GetEncoding( "utf-8" ) );
        string groupData = Server.UrlDecode( gb2312[0] );
        objReader = new System.IO.StringReader( groupData );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsGroup = new DataSet( );
        dsGroup.ReadXml( objReader );
        objReader.Close( );
        gb2312 = HttpUtility.ParseQueryString( Request[ "ExportModel" ], System.Text.Encoding.GetEncoding( "utf-8" ) );
        string colModelData = Server.UrlDecode( gb2312[0] );
        colModelData = colModelData.Replace( "$", "_" );
        objReader = new System.IO.StringReader( colModelData );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsCol = new DataSet( );
        dsCol.ReadXml( objReader );
        objReader.Close( );

        string str = ZJSIG.UIProcess.Report.ReportBase.getDataSetReport( dsData, dsCol, dsGroup );

        Response.Write( "&amp;lt;script&amp;gt;document.close();&amp;lt;/script&amp;gt;" );
        Response.Clear( );
        Response.Buffer = true;
        Response.ContentType = "application/vnd.ms-excel";
        Response.AddHeader( "Content-Disposition", "attachment;filename=\"text.xls\"" );
        Response.Charset = "";

        this.EnableViewState = false;
        System.IO.StringWriter tmpSW = new System.IO.StringWriter( );
        System.Web.UI.HtmlTextWriter tmpHTW = new System.Web.UI.HtmlTextWriter( tmpSW );
        tmpHTW.WriteLine( str );
        Response.Write( tmpSW.ToString( ) );
        Response.End( );
    }

    /// <summary>
    /// 
    /// 根据指定的编码格式返回请求的参数集合 ziqiu.zhang 2009.1.19 
    /// </summary>
    /// 
    /// <param name="request">当前请求的request对象</param> 
    /// <param name="encode">编码格式字符串</param> 
    /// <returns>键为参数名,值为参数值的NameValue集合</returns> 
    public static NameValueCollection GetRequestParameters( HttpRequest request, string encode )
    {
        NameValueCollection result = null;
        Encoding destEncode = null; //获取指定编码格式的Encoding对象 
        if ( !String.IsNullOrEmpty( encode ) )
        {
            try
            { //获取指定的编码格式 
                destEncode = Encoding.GetEncoding( encode );
            }
            catch
            {
                //如果获取指定编码格式失败,则设置为null 
                destEncode = null;
            }
        } //根据不同的HttpMethod方式,获取请求的参数.如果没有Encoding对象则使用服务器端默认的编码. 
        if ( request.HttpMethod == "POST" )
        {
            if ( null != destEncode )
            {
                Stream resStream = request.InputStream;
                byte[ ] filecontent = new byte[ resStream.Length ];
                resStream.Read( filecontent, 0, filecontent.Length );
                string postquery = destEncode.GetString( filecontent );
                result = HttpUtility.ParseQueryString( postquery, destEncode );
            }
            else
            {
                result = request.Form;
            }
        }
        else
        {
            if ( null != destEncode )
            {
                result = System.Web.HttpUtility.ParseQueryString( request.Url.Query, destEncode );
            }
            else
            {
                result = request.QueryString;
            }
        }
        //返回结果 
        return result;
    }
}
