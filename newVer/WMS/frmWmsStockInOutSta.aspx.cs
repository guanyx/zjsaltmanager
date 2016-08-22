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
using System.Text;

using ZJSIG.UIProcess.ADM;

public partial class WMS_frmWmsStockInOutSta : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {

        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        script.Append( "var posStore=" );
        script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehousePosition.getPositionSimpleStore( this.OrgID, 0 ) );
        script.Append( "\r\n" );
        script.Append( "var reportViewName='VSWmsStockInoutDetail';\r\n" );
        script.Append( "</script>" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlistinout":
                ZJSIG.UIProcess.WMS.UIWmsStockInout.getInOutStaList( this );
                break;
            case "getgroupby":
                ZJSIG.UIProcess.UIProcessBase.GetGroupStore( this, "VSWmsStockInoutDetail" );
                break;
            case "getSchemeList":
                UIAdmStaticScheme.getStaticSchemeList( this );
                break;
                break;
            case "saveScheme":
                UIAdmStaticScheme.saveStaticScheme( this );
                break;
            case "deletscheme":
                UIAdmStaticScheme.deleteScheme( this );
                break;

        }
    }
}
