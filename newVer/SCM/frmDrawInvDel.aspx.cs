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
using ZJSIG.UIProcess.SCM;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.ADM;

public partial class SCM_frmDrawInvDel : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //获取权限下的仓库
        script.Append("var dsWh = ");  //这个变量名界面combobox需要使用，保持一致
        script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        //获取领货单类型
        script.Append("var dsDrawType = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("S10"));


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
                case "getDrawInvList":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.getDrawListForDel(this);
                    break;
                case "save":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.delDrawInv(this);
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
