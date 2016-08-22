using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.BA;
public partial class QT_QtQualityProductCfg : PageBase
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
            case "getallSolt":
                ZJSIG.UIProcess.BA.UIBusinessBaProductType.getTypeListStore( this );
                break;
            case "addProd":
                ZJSIG.UIProcess.QT.UIQtQualityProductCfg.addProd( this );
                break;
            case "queryProduct":
                ZJSIG.UIProcess.QT.UIQtQualityProductCfg.queryProduct( this );
                break;
            case "delPro":
                ZJSIG.UIProcess.QT.UIQtQualityProductCfg.delProduct( this );
                break;
        }
    }
}
