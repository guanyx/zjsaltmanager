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

public partial class SCM_portel_customerLogin : System.Web.UI.Page
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString[ "method" ];
        }
        catch ( Exception ex )
        {
        }

        switch ( method )
        {
            case "login":
                Loginin( );
            break;
        }
       
    }
    public void Loginin( )
    {
        string loginName = Request.Form[ "userName" ];
        string loginPwd = Request.Form[ "password" ];

        if ( ZJSIG.UIProcess.ADM.UIAdmUser.userLogin( this ) )
        {
            Response.Write( "{\"sucess\":\"true\",\"url\":\"mainDesktop.aspx\"}" );
            Response.End( );
        }
        else
        {
            Response.Write( "{\"sucess\":\"false\",\"url\":\"customerLogin.aspx\",\"message\":\"权限验证错误,请验证用户名和密码正确后重新登录系统！\"} " );
            Response.End( );
        }
    }
}
