using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BA_sysadmin_frmWfGroupList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = this.Request.QueryString["method"];
        switch (method)
        {
            case"getgroup":
                ZJSIG.UIProcess.ADM.UIWfWorkflowGroup.getGroup(this);
                break;
            case"addgroup":
                ZJSIG.UIProcess.ADM.UIWfWorkflowGroup.addGroup(this);
                break;
            case"editgroup":
                ZJSIG.UIProcess.ADM.UIWfWorkflowGroup.editGroup(this);
                break;
            case "delgroup":
                ZJSIG.UIProcess.ADM.UIWfWorkflowGroup.deleteGroup(this);
                break;
            case "getgrouplist":
                ZJSIG.UIProcess.ADM.UIWfWorkflowGroup.getGroupList(this);
                break;
        }
    }
}
