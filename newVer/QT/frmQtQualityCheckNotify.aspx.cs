using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QT_frmQtQualityCheckNotify : PageBase
{
    protected void Page_Load( object sender , EventArgs e )
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
            case "getTemplateDetail":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.getTemplateDetail( this );
                break;
            case "getCNList":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.getCNList( this );
                break;
            case "saveCheck":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.saveCheck( this );
                break;
            case "getStardDetail":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.getStardDetail( this );
                break;
            case "recheck":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.recheck( this );
                break;
            case "secondcheck":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.secondcheck( this );
                break;
            case "showrsult":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.showrsult( this );
                break;
            case "checkpass":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.checkpass(this);
                break;
            case "confirmcheck":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.confirmcheck(this);
                break;
            case "cancelcheck":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.cancelcheck(this);
                break;
        }
    }
}
