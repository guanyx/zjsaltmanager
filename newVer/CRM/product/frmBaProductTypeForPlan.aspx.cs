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
using ZJSIG.BA.BusinessEntities;
using ZJSIG.UIProcess.BA;
using System.Text;

public partial class CRM_product_frmBaProductType : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取规格
        script.Append( "var dsOrgInfoList = " );
        
        //可以考虑当为集团公司时，将Request.Form["OrgId"] = ''
        //其他分公司时，Request.Form["OrgId"] = Session["OrgId"]
        script.Append( UIBusinessBaProductType.getOrgListStore( this ) );

        script.Append( "var dsReportTypeList = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "R01" ) );

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

            case "gettreelist":
                UIBaReportType.getBaProducctTypeTreeList( this );
                break;
            case "getModifyType":
                UIBaReportType.getType( this );
                break;
            case "editProductType":
                UIBaReportType.editType( this );
                break;
            case "deleteProductType":
                UIBaReportType.deleteType( this );
                break;
            case "forbiddenProductType":
                UIBaReportType.editType( this );
                break;
            case "saveProductType":
                if ( Request["ClassId"] == null || "".Equals( Request["ClassId"] ) )
                {
                    UIBaReportType.addType( this );
                }
                else
                {
                    UIBaReportType.editType( this );
                }
                break;
            case "getSmallClass":
                UIBaReportType.getSmallClasses( this );
                break;
            case "deleteClassesInfo":
                UIBaReportType.deleteClassesInfo( this );
                break;
            case "getNonCalsses":
                UIBaReportType.getSmallNonClasses( this );
                break;
            case "saveClassesRelInfo":
                UIBaReportType.saveClassesRelInfo( this );
                break;
            case "getbaproducttypetree":
                ZJSIG.UIProcess.BA.UIBaReportType.getBaProductTypeByReportTree( this );
                break;
            case "getClassProductList":
                string action = this.Request[ "action" ];
                if ( action == null || action == "" )
                {
                    ZJSIG.UIProcess.BA.UIBaReportType.getProductListByReport( this );
                }
                else if ( action == "add" )
                {
                    ZJSIG.UIProcess.BA.UIBaReportType.getProductListByNoReport( this );
                }
                break;
            case"getchildproduct":
                ZJSIG.UIProcess.BA.UIBaReportType.GetChildProduct( this );
                break;
            case"check":
                ZJSIG.UIProcess.BA.UIBaReportType.CheckChildProductSame( this );
                break;
            case"sameitem":
                ZJSIG.UIProcess.BA.UIBaReportType.GetSameProduct( this );
                break;
        }
    }
}
