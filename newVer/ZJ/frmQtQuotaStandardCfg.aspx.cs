using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QT_frmQtQuotaStandardCfg : PageBase
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

            case "addStandard":
                ZJSIG.UIProcess.QT.UIQtQuotaStandardCfg.addStandard( this );
                break;
            case "queryStandard":
                ZJSIG.UIProcess.QT.UIQtQuotaStandardCfg.queryStandard( this );
                break;
            case "delStandard":
                ZJSIG.UIProcess.QT.UIQtQuotaStandardCfg.delStandard( this );
                break;
            case "updateStandard":
                ZJSIG.UIProcess.QT.UIQtQuotaStandardCfg.editCfg( this );
                break;
        }
    }
}
