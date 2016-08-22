using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ZJ_frmQtQualityTemplateCfg : PageBase
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
            case "getQuotaTreeByTemplate":
                ZJSIG.UIProcess.QT.UIQtQuotaTemplateRel.getQuotaTreeByTemplate( this );
                break;
            case"saveTemplateQuotas":
                ZJSIG.UIProcess.QT.UIQtQuotaTemplateRel.saveTemplateQuotas( this );
                break;
            case"getSaltTree":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.getSaltTree( this );
                break;
            case"saveSalt":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.saveTemplateSalt( this );
                break;
        }
    }
}
