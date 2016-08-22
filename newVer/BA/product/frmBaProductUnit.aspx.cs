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
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;

public partial class BA_product_frmBaProductUnit : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取所属量纲
        script.Append( "var dsDimension = " );
        //script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.BA_PRODUCT_DIMENSION) );
        script.Append( ZJSIG.UIProcess.BA.UIBaProductUnitConvert.getDimentionUnit( this ) );

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
            case "getUnitInfo":
                ZJSIG.UIProcess.BA.UIBaProductUnit.getUnit( this );
                break;
            case "addUnitInfo":
                ZJSIG.UIProcess.BA.UIBaProductUnit.addUnit( this );
                break;
            case "saveUnitInfo":
                ZJSIG.UIProcess.BA.UIBaProductUnit.editUnit( this );
                break;
            case "deleteUnit":
                ZJSIG.UIProcess.BA.UIBaProductUnit.deleteUnit( this );
                break;
            case "getUnitList":
                ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitList( this );
                break;
        }

    }
}
