using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.BA;

public partial class QT_frmQtZJtzd : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        script.Append( "\r\n" );
        script.Append( "var dsWarehouseList = " );
        script.Append( UIWmsWarehouse.getWarehouseListInfoStore( this ) );

        script.Append( "\r\n" );
        script.Append( "var dsProductList = " );
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
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
            case "getckpd":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.getckpd( this );
                break;
            case "saveckpd":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.savezjnotify( this );
                break;
            case "delzj":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.delNotify( this );
                break;
            case "getcklist":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.getcklist( this );
                break;
            case "mofigyzj":
                ZJSIG.UIProcess.QT.UIQtQualityCheckNotify.modifyNotify( this );
                break;
            case "getPosition":
                ZJSIG.UIProcess.WMS.UIWmsWarehousePosition.getWarehousePositionListByWhId( this ); ;
                break;
        }
    }
}
