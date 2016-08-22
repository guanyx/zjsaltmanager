using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class SCM_frmPlanUp : PageBase
{
    protected string getComboBoxSource( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        //获取采购计划类型信息数据
        script.Append( "var cmbPlanTypeList =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S20" ) );

        script.Append( "var cmbStatusList =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S21" ) );

        script.Append( "var cmbPlanYearList = " );
        script.Append( ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getYearList( ) );

        script.Append( "var cmbPlanMonthList=" );
        script.Append( ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getMonthList( ) );

        script.Append( "var cmbPlanQuarteList=" );
        script.Append( ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getQuarterList( ) );

        //设置默认过滤条件
        script.Append( "var action='" + Action + "';\r\n" );
        if ( Action == "" )
        {
            script.Append( "var view = false;\r\n" );
        }
        else
        {
            script.Append( "var view = true;\r\n" );
        }

        long planId = 0;
        long.TryParse( this.Request.QueryString[ "PlanId" ], out planId );
        if ( planId > 0 )
        {
            ZJSIG.SCM.BusinessEntities.ScmPurchPlanMst itemPlan =
                ZJSIG.SCM.BLL.BLScmPurchPlanMst.GetModel( planId );
            script.Append( "var planType = '" + itemPlan.PlanType + "';\r\n" );
            script.Append( "var startDate = '" + itemPlan.StartDate.ToShortDateString() + "';\r\n" );
            int adding = 0;
            if ( itemPlan.IsAdding )
                adding = 1;
            script.Append( "var isAdding = '" + adding.ToString() + "';\r\n" );
        }

        // script.Append(initToolBar());
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }


    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        method = Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getpurchplanlist":
                ZJSIG.UIProcess.SCM.UIScmPurch.getCityUpPlanList( this );
                break;
            case"reportorg":
                ZJSIG.UIProcess.SCM.UIScmPurch.getNoReportPlanOrg( this );
                break;
            case"upcity":
                ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.addPlansSight( this );
                break;
        }
    }
}
