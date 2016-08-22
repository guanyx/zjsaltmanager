using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class BA_sysadmin_frmOrgConfig : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        script.Append( "\r\n" );
        script.Append( "var newPrintOn = " + LodopPrintOn.ToString( ).ToLower( ) + ";" );
        script.Append( "\r\n" );
        script.Append( "var printTitle = '" + PrintTitle.ToString( ).ToLower( ) + "';" );
        script.Append( "\r\n" );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "saveconfig":
                ZJSIG.UIProcess.UIMessageBase message = new ZJSIG.UIProcess.UIMessageBase( );
                try
                {
                    string newPrintOn = this.Request[ "newPrintOn" ];
                    string printTitle = this.Request[ "printTitle" ];
                    if ( newPrintOn == "true" )
                    {
                        LodopPrintOn = true;
                    }
                    else
                    {
                        LodopPrintOn = false;
                    }
                    if ( printTitle != "" )
                    {
                        PrintTitle = printTitle;
                    }
                    UpdateConfig( );
                    message.success = true;
                    message.errorinfo = "单位基本打印设置保存成功！";
                }
                catch(Exception ep)
                {
                    message.success = false;
                    message.errorinfo = "单位基本打印设置保存失败！" + ep.Message;
                }
                this.Response.Write( ZJSIG.UIProcess.UIProcessBase.ObjectToJson( message ) );
                this.Response.End( );
                break;
        }
    }
}
