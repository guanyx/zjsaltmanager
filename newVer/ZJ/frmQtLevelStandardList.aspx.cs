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

public partial class ZJ_frmQtLevelStandardList : System.Web.UI.Page
{
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.AppendLine( "<script>" );
        if ( this.Request.QueryString[ "LevelId" ] != null )
        {
            script.AppendLine( "var levelId=" + this.Request.QueryString[ "LevelId" ] + ";" );
        }
        else
        {
            script.AppendLine( "var levelId=0;");
        }
        script.AppendLine( "</script>" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlevelstandard":
                ZJSIG.UIProcess.QT.UIQtSalt.getLevelStandardList( this );
                break;
        }
    }
}
