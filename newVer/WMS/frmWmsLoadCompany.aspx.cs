using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;

public partial class WMS_frmWmsLoadCompany : PageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch
        {
        }

        switch (method)
        {
            case "getCompanyInfoAction":
                UIWmsLoadCompany.getCompany(this);
                break;

            case "deleteCompanyAction":
                UIWmsLoadCompany.deleteCompany(this);
                break;

            case "saveCompanyInfoAction":
                UIWmsLoadCompany.saveCompany(this);
                break;
            case "getCompanyListAction":
                UIWmsLoadCompany.getCompanyList(this);
                break;

        }
    }
}
