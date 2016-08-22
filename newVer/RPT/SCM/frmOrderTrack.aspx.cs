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
using ZJSIG.UIProcess.RPT;
using ZJSIG.UIProcess.SCM;

public partial class RPT_frmOrderTrack : PageBase
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlist":
                UITansLoadFee.getViewList(this);
                break;
            case "getStatusInfo":
                UIScmOrderMst.getOrderStatusInfo(this);
                break;
        }
    }
}
