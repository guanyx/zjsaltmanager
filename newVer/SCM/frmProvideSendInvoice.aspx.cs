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
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.Common;

public partial class SCM_frmProvideSendInvoice : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //发运单状态
        script.Append("var dsStatus = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore(CommonDefinition.SCM_PROVIDE_SEND_TYPE));

        //到货通知单状态
        script.Append("var dsNoticeStatus = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore(CommonDefinition.SCM_NOTICE_TYPE));

        //到站信息
        script.Append("var dsDestination = ");
        script.Append(ZJSIG.UIProcess.SCM.UIScmOrgDestinationCfg.GetAllDestinationsStore(this));

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
                case "getProvideSendList"://这里应该添加登录供应商的id来过滤
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.getMstAndDtlList(this);
                    break;
                case "getconfirmStaticList":
                    ZJSIG.UIProcess.SCM.UIScmNoticeMst.getStaticDtlList(this);
                    break;
                case "exportData":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.exportExcel(this);
                    break;
                case "getProvideSendDtl":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.getMstAndDtlList(this);
                    break;
                case "saveProvideSendDtl":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.saveProvideDataForInvoice(this);
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
    
}
