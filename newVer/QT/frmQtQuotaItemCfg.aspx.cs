using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class QT_frmQtQuotaItemCfg :PageBase
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
            case  "getType" :
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.getQuotaType(this);
                break;

            case "getAllCfgList":
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.getAllCfgList( this );
                break;
                
            case "addQuota":
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.addCfg(this);
                break;
            case "queryQuota":
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.getCfgList(this);
                break;
            case "updateQuota":
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.editCfg(this);
                break;
            case "delQuota":
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.deleteCfgBatch(this);
                break;
            case "queryQuotaByType":
                ZJSIG.UIProcess.QT.UIQtQuotaItemCfg.getCfgListByType( this );
                break;
            case "getOrgs":
                ZJSIG.UIProcess.ADM.UIAdmOrg.getOrgList(this);
                break;
        }
       

    }

}
