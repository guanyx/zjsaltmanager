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
using System.Text;

public partial class BA_sysadmin_frmResourceAction : System.Web.UI.Page
{
    protected string GetResourceID
    {
        get
        {
            string resourceID = this.Request["ResourceID"];
            string script = "<script>{0}</script>";
            return string.Format(script, "resourceID = \"" + resourceID + "\";");

        }
    }

    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取类别信息
        script.Append("var ActionTypeStore =");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A01"));

        string resourceID = this.Request["ResourceID"];
        script.Append("resourceID = \"" + resourceID + "\";\r\n");
        script.Append("</script>\r\n");
        return script.ToString();
    }

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
            //获取资源功能列表信息
            case "getactionlist":
                ZJSIG.UIProcess.ADM.UIAdmResourceaction.getResourceactionList(this);
                break;
            case"addaction":
                ZJSIG.UIProcess.ADM.UIAdmResourceaction.addResourceaction(this);
                break;
            case"editaction":
                ZJSIG.UIProcess.ADM.UIAdmResourceaction.editResourceaction(this);
                break;
            case"delaction":
                ZJSIG.UIProcess.ADM.UIAdmResourceaction.deleteResourceaction(this);
                break;
            case"getaction":
                ZJSIG.UIProcess.ADM.UIAdmResourceaction.getResourceaction(this);
                break;
            
        }
    }
}
