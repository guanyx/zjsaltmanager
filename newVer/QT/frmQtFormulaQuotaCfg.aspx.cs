using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QT_frmQtFormulaQuotaCfg : PageBase
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
            case "queryQuotaByType":
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.getCfgListByType( this );
                break;
            case "addFormula":
                ZJSIG.UIProcess.QT.UIQtQuotaFormulaCfg.addFormula( this );
                break;
            case "queryFormula":
                ZJSIG.UIProcess.QT.UIQtQuotaFormulaCfg.getCfgList( this );
                break;
            case "delFormula":
                ZJSIG.UIProcess.QT.UIQtQuotaFormulaCfg.delFormulaBc( this );
                break;
            case "updateFormula":
                ZJSIG.UIProcess.QT.UIQtQuotaFormulaCfg.editCfg( this );
                break;
        }
    }
}
