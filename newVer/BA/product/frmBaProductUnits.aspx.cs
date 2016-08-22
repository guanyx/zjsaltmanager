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
using ZJSIG.UIProcess.BA;

public partial class BA_product_frmBaProductUnits : System.Web.UI.Page
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取单位
        script.Append( "var dsUnitList =" );
        script.Append( UIBaProductUnit.getUnitInfoStore( ) );

        script.Append( "var productId = '" + this.Request.QueryString[ "ProductId" ] + "';\r\n" );
        script.Append( "var productName = '" + this.Request.QueryString[ "ProductName" ] + "';\r\n" );
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
            case "getproductunits":
                ZJSIG.UIProcess.BA.UIBaProduct.getProductUnits( this );
                break;
            case"save":
                ZJSIG.UIProcess.BA.UIBaProduct.saveProductUnits( this );
                break;
        }
    }
}
