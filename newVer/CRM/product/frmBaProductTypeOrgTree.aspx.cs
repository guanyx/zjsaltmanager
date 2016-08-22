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

public partial class CRM_product_frmBaProductTypeOrgTree : PageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch (Exception ex)
        {
        }
        switch (method)
        {
            case "saveReportType":
                ZJSIG.UIProcess.BA.UIBaReportTypeOrg.saveClassOrgs(this);
                break;
            case "getcurrentandchildrentree":
                ZJSIG.UIProcess.BA.UIBaReportTypeOrg.getCurrentAndChildrenTree(this);
                break;
            case "getcurrentAndChildrenTreeByArea":
                ZJSIG.UIProcess.BA.UIBaReportTypeOrg.getcurrentAndChildrenTreeByArea(this);
                break;
        }
    }
}
