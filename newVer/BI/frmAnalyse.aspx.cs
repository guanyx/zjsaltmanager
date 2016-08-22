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

public partial class BI_frmAnalyse : System.Web.UI.Page
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request[ "method" ];
        switch ( method )
        {
            case "Analyse":
                DateTime startDate = DateTime.Parse( this.Request[ "StartDate" ] );
                long orgId = long.Parse( this.Request[ "OrgId" ] );
                ZJSIG.UIProcess.BI.IAnalyse analyse = new ZJSIG.UIProcess.BI.SaleAnalyse( );
                analyse.StartDate = startDate;
                analyse.EndDate = startDate.AddMonths( 1 );
                analyse.OrgId = orgId;
                string message = analyse.getAnalyse( );
                this.Response.Write( message );
                this.Response.End();
                break;
        }
    }
}
