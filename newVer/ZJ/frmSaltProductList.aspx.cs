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

public partial class ZJ_frmSaltProductList : System.Web.UI.Page
{
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.AppendLine( "<script>" );
        script.AppendLine( "saltId = '" + this.Request.QueryString[ "SaltId" ] + "';" );
        script.AppendLine( "</script>" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "Method" ];
        switch ( method )
        {
            case "getSaltProductList":
                ZJSIG.UIProcess.QT.UIQtSalt.getSaltProductList( this );
                break;
            case"getProductList":
                ZJSIG.UIProcess.QT.UIQtSalt.getSaltNoProductList( this );
                break;
            case"saveSaltProduct":
                ZJSIG.UIProcess.QT.UIQtSalt.saveSaltProduct( this );
                break;
            case"delSaltProduct":
                ZJSIG.UIProcess.QT.UIQtSalt.delSaltProduct( this );
                break;
        }

    }
}
