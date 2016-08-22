using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QT_frmQtQualityTemplateCfg : PageBase
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
            case "getQuota":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.getQuotaType(this);
                break;
            case "addQuotaTemplate":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.addQuotaTemplate(this);
                break;
            case "getTemplateList":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.getTemplateList(this);
                break;
            case "delQuotaTemplate":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.delQuotaTemplate(this);
                break;
            case "getTemplateDetail":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.getTemplateDetail(this);
                break;
            case "modifyQuotaTemplate":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.modifyQuotaTemplate(this);
                break;
        }
    }
}
