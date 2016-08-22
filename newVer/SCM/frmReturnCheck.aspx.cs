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

public partial class SCM_frmReturnCheck : PageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                //退货单列表
                case "getReturnList":
                    ZJSIG.UIProcess.SCM.UIScmReturn.getReturnList(this);
                    break;
                
                //退货单审核
                case "checkReturn":
                    ZJSIG.UIProcess.SCM.UIScmReturnCheck.checkReturn(this);
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
