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

public partial class ZJ_frmQuotaItemSelect : System.Web.UI.Page
{
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.AppendLine( "<script>" );
        if ( this.Request.QueryString[ "TemplateNo" ] == null )
        {
            script.AppendLine( "quotaType = 'report';" );
        }
        else
        {
            script.AppendLine( "quotaType = 'template';" );
        }
        //script.AppendLine("var type="+
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
                ZJSIG.UIProcess.QT.UIQtQuotaTemplateRel.getQuotaListByTemplate( this );
                break;
            case "saveQuota":
                switch ( this.Request[ "QuotaType" ] )
                {
                    case"template":
                        ZJSIG.UIProcess.QT.UIQtQuotaTemplateRel.addTemplateQuotas( this );
                        break;
                    default:
                        ZJSIG.UIProcess.QT.UIQtReport.saveReportQuotas( this );
                        break;
                }
                
                break;
        }
    }
}
