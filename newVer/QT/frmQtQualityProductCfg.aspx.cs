using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.BA;
using System.Text;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;
public partial class QT_QtQualityProductCfg : PageBase
{

    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        ////获取规格
        //script.Append( "var dsSpecifications = " );
        //script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.BA_PRODUCT_SPECIFICATION ) );

        //获取产地
        script.Append( "var dsOrigin =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.BA_PRODUCT_ORIGIN ) );

        //获取单位
        script.Append( "var dsUnit =" );
        script.Append( UIBaProductUnit.getUnitInfoStore( ) );

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
            case "getallSolt":
                ZJSIG.UIProcess.QT.UIQtQualityProductCfg.getTypeListStore( this );
              //  ZJSIG.UIProcess.BA.UIBusinessBaProductType.getTypeListStore( this );
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
            case "updatePro":
                ZJSIG.UIProcess.QT.UIQtQualityProductCfg.editCfg( this );
                break;
            case "getSmallClasses":
                ZJSIG.UIProcess.BA.UIBaProduct.getProductListForDropDownList( this );
                break;
        }
    }
}
