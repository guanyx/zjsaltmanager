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
using ZJSIG.UIProcess.CRM;
using System.Collections.Generic;

public partial class SCM_portel_mainDesktop : PageBase
{
    public string CustomerAddr = "";
    public string CustomerNo = "";
    public string CustomerName = "";
    public string LinkMan = "";
    public string CustomerId = "";
    public string OrgId = "";
    protected void Page_Load( object sender, EventArgs e )
    {
         Dictionary<string,string> list = UIBusinessCrmCustomer.getCustomerByCustomerId( this );
         list.TryGetValue( "DeliverAdd", out CustomerAddr );
         list.TryGetValue( "CustomerNo", out CustomerNo );
         list.TryGetValue( "ChineseName", out CustomerName );
         list.TryGetValue( "LinkMan", out LinkMan );
         list.TryGetValue( "CustomerId", out CustomerId );
         list.TryGetValue("OrgId", out OrgId);
    }
}
