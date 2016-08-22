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
using System.Xml.Linq;
using ZJSIG.UIProcess.Common;
using System.Text;
using ZJSIG.UIProcess.BA;

public partial class PMS_frmPmsBagManagemen : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //编织袋流转状态
        script.Append( "var dsStatus = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( CommonDefinition.PMS_WS_BAG_STATUS ) );


        //车间列表
        script.Append( "var dsWs = " );
        script.Append( ZJSIG.UIProcess.PMS.UIPmsWorkshop.getWorkshopListStore( this ) );

        //获取商品列表(应该是供应商下面的小类，这里应该管理进去供应商)
        script.Append( "\r\n" );
        script.Append( "var dsProductList = " );
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
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
            case "getmanagement":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.getManagement( this );
                break;
            case "getManagementList":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.getManagementList( this );
                break;

            case "addOne":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.addManagement( this );
                break;
            case "editOne":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.editManagement( this );
                break;
            case "acceptTwo":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.acceptManagement( this );
                break;
            case "editTwo":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.editManagement( this );
                break;
            case "saleTwo":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.addManagementTwo( this );
                break;
            case "acceptThree":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.acceptManagement( this );
                break;
            case "editThree":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.editManagement( this );
                break;
            case "acceptFour":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.acceptManagement( this );
                break;
            case "editFour":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.editManagementFour( this );
                break;
            case "produceFour":
                ZJSIG.UIProcess.PMS.UIPmsBagManagement.addManagementFour( this );
                break;
        }
    }
}
