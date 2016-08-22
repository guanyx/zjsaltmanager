using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QT_frmSolutionCfg : PageBase
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
            case "getSolutionItems":
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.getSoluCfgList( this );
                break;
            case "addSolution":
                ZJSIG.UIProcess.QT.UIQtQualifySolutionCfg.addCfg( this );
                break;
            case "getSolution":
                ZJSIG.UIProcess.QT.UIQtQualifySolutionCfg.queryCfgList( this );
                break;
            case "delSolution":
                ZJSIG.UIProcess.QT.UIQtQualifySolutionCfg.delSolu( this );
                break;
            case "updateSolution":
                ZJSIG.UIProcess.QT.UIQtQualifySolutionCfg.editCfg( this );
                break;
        }
    }
}
