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
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.WMS;

public partial class BA_product_frmNegtiveStockLimit : PageBase
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
        script.Append( "var dsDistributionCenterListInfo = " );
        script.Append( UIAdmDept.getDistributionCenterStore( this ) );

        //获取组织
        script.Append( "var dsOrg = " );  //这个变量名界面combobox需要使用，保持一致
        //可以考虑当为集团公司时，将Request.Form["OrgId"] = ''
        //其他分公司时，Request.Form["OrgId"] = Session["OrgId"]
        script.Append( ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getOrgListStore( this ) );

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

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {

            method = Request.QueryString[ "method" ];
            switch ( method )
            {
                case "getProductInfoList":
                    ZJSIG.UIProcess.BA.UIBaAllowNegativeProduct.getProductList( this );
                    break;
                case "deleteProductInfo":
                    ZJSIG.UIProcess.BA.UIBaAllowNegativeProduct.deleteProduct( this );
                    break;
                case "addCfg":
                    ZJSIG.UIProcess.BA.UIBaAllowNegativeProduct.addProduct( this );
                    break;                    
                case "getWhSimple"://根据公司得到仓库列表
                    ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListByOrgId( this );
                    break;
                case "getAllProducts":
                    ZJSIG.UIProcess.BA.UIBaProduct.getProductList( this );
                    //ZJSIG.UIProcess.BA.UIBaProduct.getProductListForNegtiveInOut( this );
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
