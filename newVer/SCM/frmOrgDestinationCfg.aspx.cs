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
using System.Text;

public partial class SCM_frmOrgDestinationCfg : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //发运方式  
        script.Append("var dsTransType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A40"));

        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                case "getOrgInfo":
                    ZJSIG.UIProcess.ADM.UIAdmOrg.getOrgByCode(this);
                    break;
                case "add":
                    ZJSIG.UIProcess.SCM.UIScmOrgDestinationCfg.addCfg(this);
                    break;
                case "edit":
                    ZJSIG.UIProcess.SCM.UIScmOrgDestinationCfg.editCfg(this);
                    break;
                case "getcfg":
                    ZJSIG.UIProcess.SCM.UIScmOrgDestinationCfg.getCfg(this);
                    break;
                case "deleteCfg":
                    ZJSIG.UIProcess.SCM.UIScmOrgDestinationCfg.deleteCfg(this);
                    break;
                case "getlist":
                    ZJSIG.UIProcess.SCM.UIScmOrgDestinationCfg.getCfgList(this);
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
