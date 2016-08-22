using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;

public partial class WMS_frmWMSStockInOutRate : PageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = this.Request.QueryString["method"];
        switch (method)
        {
            case "getlistinout":
                UIWmsStockInOutRate.getStockInOutList(this);
                break;
            case "getgroupby":
                ZJSIG.UIProcess.UIProcessBase.GetGroupStore(this, "VWmsStockInoutRate");
                break;
                
        }
    }
}
