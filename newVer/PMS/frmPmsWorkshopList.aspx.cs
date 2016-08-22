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

public partial class PMS_frmPmsWorkshop : PageBase
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
            case "getWorkshopList":
                ZJSIG.UIProcess.PMS.UIPmsWorkshop.getWorkshopList(this);
                break;
            case "getworkshop":
                ZJSIG.UIProcess.PMS.UIPmsWorkshop.getWorkshop( this );
                break;
            case "deleteWorkshop":
                ZJSIG.UIProcess.PMS.UIPmsWorkshop.deleteWorkshop( this );
                break;
            case "addWorkshop":
                ZJSIG.UIProcess.PMS.UIPmsWorkshop.addWorkshop( this );
                break;
            case "saveWorkshop":
                ZJSIG.UIProcess.PMS.UIPmsWorkshop.editWorkshop( this );
                break;
            case "getEmpInfoList":
                ZJSIG.UIProcess.PMS.UIPmsWorkshop.getEmpInfo( this );
                break;
        }      
    }
}
