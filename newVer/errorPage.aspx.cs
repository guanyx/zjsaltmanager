using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class errorPage : System.Web.UI.Page
{
    /**
     * 错误信息
     */
    public string errMessage = "";
    public string errCode = "";//1001需要重新登录
    protected void Page_Load( object sender, EventArgs e )
    {
        errCode = Request.QueryString["errCode"];
        if (errCode == "1001")
        {
            errMessage = "用户名或密码错误，请重新登陆。<a href='login.html'>登陆</a>";
        }
        else if ( errCode == "1003" )
        {
            errMessage = this.Request.Params[ "errMessage" ].ToString( ) ;
        }
        else
        {
            if ( Session[ "error" ] != null )
            {
                //errorMessageLabel.Text = Application[ "error" ].ToString( );
                errMessage = Session[ "error" ].ToString( );
            }
        }
        
        this.Response.Write( errMessage );
    }
}
