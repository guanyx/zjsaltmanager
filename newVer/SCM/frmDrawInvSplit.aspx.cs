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
using ZJSIG.UIProcess;
using System.Text;

public partial class SCM_frmDrawInvSplit : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //领货单类型
        script.Append("var dsDrawType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S10"));

        script.Append("</script>\r\n");
        return script.ToString();
    }


    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                //领货单列表
                case "getDrawInvList":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.getDrawList(this);
                    break;
                //可分割明细
                case "getDrawDtlList":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.getDrawDtlList(this);
                    break;
                //保存
                case "saveUpdate":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.saveUpdate(this);
                    break;
                case "getdrawdetail":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.getDrawDetailInfo( this );
                    break;

            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }


}
