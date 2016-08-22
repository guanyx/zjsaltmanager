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

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string strPlanType = "";
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
            case "getTypeList":
                UIBusinessBaProductType.getTypeList( this );
                break;
            case "gettreelist":
                UIBusinessBaProductType.getBaProducctTypeTreeList( this );
                break;
            case "getModifyType":
                UIBusinessBaProductType.getType( this );
                break;
            case "deleteProductType":
                UIBusinessBaProductType.deleteType( this );
                break;
            case "forbiddenProductType":
                UIBusinessBaProductType.editType( this );
                break;
            case "saveProductType":
                if ( Request["ClassId"] == null || "".Equals( Request["ClassId"] ) )
                {
                    UIBusinessBaProductType.addType( this );
                }
                else
                {
                    UIBusinessBaProductType.editType( this );
                }
                break;
        }
    }
}
