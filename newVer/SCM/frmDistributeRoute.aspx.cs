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
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.SCM;
using ZJSIG.UIProcess.CRM;

public partial class SCM_frmDistributeRoute : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取订单类型
        script.Append( "var dsRouteType = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.SCM_ROUTE_TYPE ) );

        //获取人员
        script.Append( "var dsOper = " );
        script.Append( UIAdmEmployee.getEmployeeListStore(this) );

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

            case "deleteRoute":
                UIScmDistributionRoute.deleteRoute( this );
                break;
            case "addRoute":
                UIScmDistributionRoute.addRoute( this );
                break;
            case "saveRoute":
                UIScmDistributionRoute.editRoute( this );
                break;
            case "getRoute":
                UIScmDistributionRoute.getRoute(this);
                break;
            case "getRouteList":
                UIScmDistributionRoute.getRouteList(this);
                break;
            case "getRouteCustomerList":
                UIScmDistributionRouteRel.getRelList( this );
                break;
            case "deleteRouteCustomerInfo":
                UIScmDistributionRouteRel.deleteRelMore( this );
                break;
            case "getNonCustomers"://内部客户和客商
                UIBusinessCrmCustomer.getCustomerList( this );
                break;
            case "saveCustomerRelInfo":
                UIScmDistributionRouteRel.saveCustomerRelInfo( this );
                break;
        }
    }
}
