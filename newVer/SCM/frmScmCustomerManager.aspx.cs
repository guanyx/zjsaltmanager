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

public partial class SCM_frmScmCustomerManager : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //
        script.Append("var dsEmpList = ");
        script.Append(ZJSIG.UIProcess.ADM.UIAdmEmployee.getEmployeeListStore(this));


        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = Request.QueryString["method"];

        switch (method)
        {
            //保存记录
            case "saveAdd":
                ZJSIG.UIProcess.SCM.UIScmOrderMst.setOrderCustomerManager(this);
                break;
        }
    }
}
