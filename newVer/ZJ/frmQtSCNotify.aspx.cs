using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QT_frmQtSCNotify : PageBase
{
    protected void Page_Load( object sender , EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch (Exception ex)
        {
        }
        switch (method)
        {
            case "getCheckOrgName":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.getCheckOrgName(this);
                break;
        }
    }
}
