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

public partial class WMS_frmWmsProductCostAlg : PageBase
{
    protected void Page_Load( object sender, EventArgs e )
    {

        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch ( Exception ex )
        {
        }

        switch ( method )
        {
            case "getAlgList":
                ZJSIG.UIProcess.WMS.UIWmsProductCostAlg.getAlgList( this );
                break;
            case "getAlg":
                ZJSIG.UIProcess.WMS.UIWmsProductCostAlg.getAlg( this );
                break;
            case "saveAlg":
                ZJSIG.UIProcess.WMS.UIWmsProductCostAlg.saveAlg( this );
                break;
            case "deleteAlg":
                ZJSIG.UIProcess.WMS.UIWmsProductCostAlg.deleteAlg( this );
                break;

        }
    }
}
