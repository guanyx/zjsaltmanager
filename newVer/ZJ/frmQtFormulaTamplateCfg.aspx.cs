using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QT_frmQtFormulaTamplateCfg : PageBase
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
            case "addFmTemplate":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.addQuotaTemplate( this );
                break;
        }
    }
}
