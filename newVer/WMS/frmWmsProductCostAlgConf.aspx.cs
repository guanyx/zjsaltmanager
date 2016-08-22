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
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.WMS;
using System.Text;

public partial class WMS_frmWmsProductCostAlgConf : PageBase
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

        //算法下拉框
        script.Append( "var dsFormula = " );
        script.Append( ZJSIG.UIProcess.WMS.UIWmsProductCostAlg.getAlgListStore( this ) );

        //商品
        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

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
            case "saveAlgConf":
                UIWmsProductCostAlgConf.saveConf( this );
                break;
            case "getAlgConf":
                UIWmsProductCostAlgConf.getConf( this );
                break;
            case "getAlgConfList":
                UIWmsProductCostAlgConf.getConfList( this );
                break;
            case "deleteConf":
                UIWmsProductCostAlgConf.deleteConf( this );
                break;
            case "getProducts":
                UIBaProduct.getProductListForDropDownList( this );
                break;
        }
    }
}
