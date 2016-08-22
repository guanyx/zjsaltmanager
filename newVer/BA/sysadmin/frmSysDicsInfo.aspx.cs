using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.ADM;

public partial class sysadmin_frmysDicsInfo : PageBase
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
            case "getDicsInfoList":
                UISysDicsInfo.getSysDicsInfoList( this );
                break;
            case "getModifyDicsInfo":
                UISysDicsInfo.getSysDicsInfo( this );
                break;
            case "saveModifyDicsInfo":
                UISysDicsInfo.saveSysDicsInfo( this );
                break;
            case "saveAddDicsInfo":
                UISysDicsInfo.addSysDicsInfo( this );
                break;
            case "deleteDicsInfo":
                UISysDicsInfo.deleteDicsInfo( this );
                break;
            default:
                return;
        }
    }
}
