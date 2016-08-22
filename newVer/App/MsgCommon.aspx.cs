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

public partial class App_MsgCommon : System.Web.UI.Page
{
    protected void Page_Load( object sender, EventArgs e )
    {
        Encoding utf8 = Encoding.GetEncoding( "utf-8" );
        Response.ContentEncoding = utf8;
        string command = this.Request.QueryString[ "cmd" ];
        if ( command == null )
        {
            command=this.Request["cmd"];
            ExpressCommand( command, "post" );
        }
        else
        {
            ExpressCommand( command, "get" );
        }
        
    }

    private void ExpressCommand(string command,string method )
    {
        if ( command == null )
            return;
        switch ( command.ToLower() )
        {
            case"login":
                new ZJSIG.UIProcess.App.UIAppServer( ).logIn( this, method );
                break;
            case"logout":
                new ZJSIG.UIProcess.App.UIAppServer( ).logout( this, method );
                break;
            case"modifypw":
                new ZJSIG.UIProcess.App.UIAppServer( ).modifyPassWord( this, method );
                break;
        }
    }

    
}
