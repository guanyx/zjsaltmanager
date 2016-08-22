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
using ZJSIG.UIProcess.SCM;
using System.Text;
using ZJSIG.UIProcess.CRM;

public partial class SCM_frmDistributeRouteRel : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

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

            case "getroutetreelist":
                UIScmDistributionRoute.getLineTreeByOrg(this);
                break;
            case "getRouteCustomerList":
                UIScmDistributionRouteRel.getRelList(this);
                break;
            case "deleteRouteCustomerInfo":
                UIScmDistributionRouteRel.deleteRel(this);
                break;
            case "getNonCustomers":
                UIBusinessCrmCustomer.getCustomerList(this);
                break;
            case "saveCustomerRelInfo":
                UIScmDistributionRouteRel.saveCustomerRelInfo(this);
                break;
        }
    }
}
