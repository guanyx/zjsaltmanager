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

public partial class FM_frmFmAccReceCheckDesk : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {

        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");


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
                case "getCustomerAccReceList":
                    ZJSIG.UIProcess.SCM.UIScmSaleCheck.getPreMoneyList(this);
                    break;
                case "getAccountNoneReceDtl":
                    ZJSIG.UIProcess.SCM.UIScmSaleCheck.getNoneCheckOrderDtlList(this);
                    break;
                case "saveCheckData"://保存
                    ZJSIG.UIProcess.SCM.UIScmSaleCheck.saveAddOrUpdateSaleCheck(this);
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
