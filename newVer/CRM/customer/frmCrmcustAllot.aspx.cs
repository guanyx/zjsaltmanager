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

public partial class CRM_customer_frmCrmcustAllot : PageBase
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string strCustomerId = "";
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
            case "getCustomerAllots":
                //得到所有客户分配信息
                ZJSIG.UIProcess.CRM.UICrmCustomerAllot.getAllotList( this );
                break;
            case "deleteCfgInfo":
                //删除
                ZJSIG.UIProcess.CRM.UICrmCustomerAllot.deleteAllot( this );
                break;
        }
    }
}
