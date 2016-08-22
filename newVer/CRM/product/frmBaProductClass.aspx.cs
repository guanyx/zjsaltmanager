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

public partial class CRM_product_frmBaProductClass : PageBase
{
    /**
     * 本页面是非计划类分类操作
     */
    public string isPlanType = "false";
    protected void Page_Load( object sender, EventArgs e )
    {
        string strPlanType = "";
        string method = "";
        try
        {
            method = Request.QueryString[ "method" ];

            strPlanType = Request.QueryString[ "planType" ];//菜单后面的参数
            if ( strPlanType != null && strPlanType != "" )
                strPlanType = Request.Form[ "isPlanType" ];//如果是异步则从param中取

            if ( strPlanType != null && strPlanType != "" && strPlanType != isPlanType )
                isPlanType = strPlanType;

        }
        catch ( Exception ex )
        {
        }
        switch ( method )
        {
            case "gettreelist":
                ZJSIG.UIProcess.BA.UIBusinessBaProductType.getBaProducctTypeTreeList( this );
                break;
            case "deleteProductInfo":
                ZJSIG.UIProcess.BA.UIBaProductClass.deleteClass( this );
                break;
            case "getProducts": //获取还未添加的商品信息
                ZJSIG.UIProcess.BA.UIBaProductSmallClass.getClassList( this );
                break;
            case "saveProductRelInfo": //保存刚添加的对应关系
                ZJSIG.UIProcess.BA.UIBaProductClass.addClass( this );
                break;
            case "getClassProducts"://得到已经建立对应关系的商品
                ZJSIG.UIProcess.BA.UIBaProductClass.getClassList( this );
                break;
            case "getbaproducttypetree":
                ZJSIG.UIProcess.BA.UIBusinessBaProductType.getBaProductTypeTree( this );
                break;
            case "getbaproducttree":
                ZJSIG.UIProcess.BA.UIBusinessBaProductType.getBaProductTree( this );
                break;
        }
    }
}
