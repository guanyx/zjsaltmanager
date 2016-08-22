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

public partial class CRM_customer_frmCrmcustAllotAdd : PageBase
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
            case "getorgtreelist":
                string nodeId = Request.Form["node"];
                if ( nodeId == "0" )
                    this.Response.Write( "[{'cls':'folder','id':10,'leaf':false,'text':'Benz'}]  " );
                if ( nodeId == "10" )
                    this.Response.Write( "[{'cls':'folder','id':11,'leaf':true,'text':'LMeterz'}]  " );
                this.Response.End( );
                break;
            case "getopertreelist":
                string nodeIds = Request.Form["node"];
                if ( nodeIds == "0" )
                    this.Response.Write( "[{'cls':'folder','id':10,'leaf':false,'text':'Benz'}]  " );
                if ( nodeIds == "10" )
                    this.Response.Write( "[{'cls':'folder','id':11,'leaf':true,'text':'LMeterz'}]  " );
                this.Response.End( );
                break;
            case "getCustomers":
                //得到所有客户信息
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getCustomerList( this );
                break;
            case "saveOrgDistr":
                //
                break;
            case "saveOperDistr":
                //
                break;
        }
    }
}
