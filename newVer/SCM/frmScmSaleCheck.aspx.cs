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
using System.Text;

using ZJSIG.UIProcess.SCM;

public partial class SCM_frmScmSaleCheck : PageBase
{

    protected string getComboBoxSource( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        script.AppendLine( "var orgName='" + this.OrgName + "';" );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";

        method = Request.QueryString[ "method" ];

        switch ( method )
        {

            case "getnochecklist":
                UIScmSaleCheck.getNoCheckSalesList( this );
                break;
            case "save":
                UIScmSaleCheck.addCheck( this );
                break;
            case "getdtllist":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.getMessageDetailList( this );
                break;

        }

    }
}
