using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QT_frmQtOtherOptionCfg : PageBase
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
            case "getOption":
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.getQuotaType( this );
                break;
            case "queryOption":
                ZJSIG.UIProcess.QT.UIQtOtherOptionCfg.queryCfgList( this );
                break;
            case "getSolution":
                ZJSIG.UIProcess.QT.UIQtQualifySolutionCfg.queryCfgList( this );
                break;
            case "addOption":
                ZJSIG.UIProcess.QT.UIQtOtherOptionCfg.addCfg( this ); 
                break;
            case "deloption":
                ZJSIG.UIProcess.QT.UIQtOtherOptionCfg.delOption( this );
                break;
            case "updateOption":
                ZJSIG.UIProcess.QT.UIQtOtherOptionCfg.editCfg( this );
                break;
            case "queryByCode":
                ZJSIG.UIProcess.QT.UIQtOtherOptionCfg.queryByCode( this );
                break;
        }
    }
}
