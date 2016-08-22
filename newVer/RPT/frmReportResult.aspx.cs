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

public partial class RPT_frmReportResult : PageBase
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = Request.QueryString["method"];
        switch (method)
        {
            case "getCusByConLike"://客户列表
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSaleCustomerListForDropDownList( this );
                break;
        }
    }
}
