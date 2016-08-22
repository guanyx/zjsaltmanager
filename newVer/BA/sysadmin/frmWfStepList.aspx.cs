using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BA_sysadmin_frmWfStepList : System.Web.UI.Page
{
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取部门类型信息
        script.Append("var wfid ='");
        script.Append(this.Request.QueryString["wfid"]);
        script.Append("';\r\n");


        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = this.Request.QueryString["method"];
        switch (method)
        {
            case "getstep":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStep.getStep(this);
                break;
            case "addstep":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStep.addStep(this);
                break;
            case "editstep":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStep.editStep(this);
                break;
            case "delstep":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStep.deleteStep(this);
                break;
            case "getsteplist":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStep.getStepList(this);
                break;
        }
    }
}
