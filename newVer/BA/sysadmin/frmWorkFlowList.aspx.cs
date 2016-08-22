using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BA_sysadmin_frmWorkFlowList : System.Web.UI.Page
{
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取部门类型信息
        script.Append("var groupId ='");
        script.Append(this.Request.QueryString["groupId"]);
        script.Append("';\r\n");


        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = this.Request.QueryString["method"];
        switch (method)
        {
            case "addworkflow":
                ZJSIG.UIProcess.ADM.UIWfWorkflow.addWorkflow(this);
                break;
            case "getworkflow":
                ZJSIG.UIProcess.ADM.UIWfWorkflow.getWorkflow(this);
                break;
            case "editworkflow":
                ZJSIG.UIProcess.ADM.UIWfWorkflow.editWorkflow(this);
                break;
            case"delworkflow":
                ZJSIG.UIProcess.ADM.UIWfWorkflow.deleteWorkflow(this);
                break;
            case "getworkflowlist":
                ZJSIG.UIProcess.ADM.UIWfWorkflow.getWorkflowList(this);
                break;
        }
    }
}
