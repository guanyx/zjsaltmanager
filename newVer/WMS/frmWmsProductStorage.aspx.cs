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
using System.Text;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.BA;

public partial class WMS_frmWmsProductStorage : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //仓库列表
        script.Append( "var dsWh =" );
        script.Append( UIWmsWarehouse.getWarehouseListInfoStore( this ) );
        //商品
        //script.Append("\r\n");
        //script.Append("var dsProductList = ");
        //script.Append( UIBaProduct.getProductListInfoStore( this ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];

        }
        catch ( Exception ex )
        {
        }
        switch ( method )
        {
            case "saveStorage":
                UIWmsProductStorage.saveStorage( this );
                break;
            case "getStorage":
                UIWmsProductStorage.getStorage( this );
                break;
            case "getStorageList":
                UIWmsProductStorage.getStorageList( this );
                break;
            case "deleteStorage":
                UIWmsProductStorage.deleteStorage( this );
                break;
            case "getProducts":
                UIBaProduct.getProductListForDropDownList( this );
                break;
            case "getWarehousePosList":
                UIWmsWarehousePosition.getWarehousePositionListByWhId( this );
                break;
            case "saveStoreWhp":
                UIWmsProductStorage.saveStorageWhp( this );
                break;
            case "getAllWhp":
                UIWmsProductStorageWhp.getWhpList( this );
                break;
        }
    }
}
