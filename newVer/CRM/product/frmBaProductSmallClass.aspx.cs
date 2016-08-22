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
using ZJSIG.UIProcess.ADM;
using System.Text;
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.CRM;

public partial class CRM_product_frmBaProductClass : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        ////获取规格
        //script.Append( "var dsSpecifications = " );
        //script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.BA_PRODUCT_SPECIFICATION ) );

        //获取单位
        script.Append( "var dsUnit =" );
        script.Append( UIBaProductUnit.getUnitInfoStore( ) );

        //获取供应商
        //script.Append( "var dsSpplier =" );
        //script.Append( UIBusinessCrmCustomer.getSuppliesListInfoStore() );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

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
            method = Request.QueryString["method"];

            strPlanType = Request.QueryString["planType"];//菜单后面的参数
            if ( strPlanType != null && strPlanType != "" )
                strPlanType = Request.Form["isPlanType"];//如果是异步则从param中取

            if ( strPlanType != null && strPlanType != "" && strPlanType != isPlanType )
                isPlanType = strPlanType;

        }
        catch ( Exception ex )
        {
        }
        switch ( method )
        {
            case "deleteSmallClass":
                ZJSIG.UIProcess.BA.UIBaProductSmallClass.deleteClass( this );
                break;
            case "getSmallClass":
                ZJSIG.UIProcess.BA.UIBaProductSmallClass.getClass( this );
                break;
            case "addSmallClass":
                ZJSIG.UIProcess.BA.UIBaProductSmallClass.addClass( this );
                break;
            case "saveSmallclass": 
                ZJSIG.UIProcess.BA.UIBaProductSmallClass.editClass( this );
                break;
            case "getSmallClassList":
                ZJSIG.UIProcess.BA.UIBaProductSmallClass.getClassList( this );
                break;
            case "getProductNo":
                ZJSIG.UIProcess.BA.UIBaProduct.getNextProductNo(this);
                break;
        }
    }
}
