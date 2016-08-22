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

public partial class ZJ_frmReportQuota : System.Web.UI.Page
{
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.AppendLine( "<script>" );
     

        script.AppendLine( "var pkId = '" + this.Request.QueryString[ "pkId" ] + "';" );
        script.AppendLine( "</script>" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case"getlist":
                ZJSIG.UIProcess.QT.UIQtReport.getReportSetQuota( this );
                break;
            case"del":
                ZJSIG.UIProcess.QT.UIQtReport.delReportSetQuota( this );
                break;
        }
    }
}
