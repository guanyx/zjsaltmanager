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
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.Common;

public partial class PMS_frmPmsPlan : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //月份
        script.Append( "var dsYear = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getYearList( ) );

        //年份
        script.Append( "var dsMonth = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getMonthList( ) );

        //车间列表
        script.Append( "var dsWs = " );
        script.Append( ZJSIG.UIProcess.PMS.UIPmsWorkshop.getWorkshopListStore( this ) );


        //获取商品列表(应该是供应商下面的小类，这里应该管理进去供应商)
        script.Append( "\r\n" );
        script.Append( "var dsProductList = " );
        script.Append( UIBaProduct.getProductListInfoStore( this  ) );

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
            case "getPmsPlanList":
                ZJSIG.UIProcess.PMS.UIPmsPlan.getPlanList( this );
                break;
            case "getplandtllist":
                ZJSIG.UIProcess.PMS.UIPmsPlanDetail.getDetailList( this );
                break;
            case "getplan":
                ZJSIG.UIProcess.PMS.UIPmsPlan.getPlan( this );
                break;
            case "deletePlan":
                ZJSIG.UIProcess.PMS.UIPmsPlan.deletePlan( this );
                break;
            case "addPlan":
                ZJSIG.UIProcess.PMS.UIPmsPlan.addPlan( this );
                break;
            case "savePlan"://界面不支持用户删除明细，要么新增，要么修改，要么全部删除重建
                ZJSIG.UIProcess.PMS.UIPmsPlan.editPlan( this );
                break;
        }  
    }
}
