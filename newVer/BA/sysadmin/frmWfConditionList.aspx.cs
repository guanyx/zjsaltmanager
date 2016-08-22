using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BA_sysadmin_frmWfConditionList : System.Web.UI.Page
{
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取部门类型信息
        script.Append("var stepId ='");
        script.Append(this.Request.QueryString["stepId"]);
        script.Append("';\r\n");

        script.Append( "var stepStore = " );
        script.Append(ZJSIG.UIProcess.ADM.UIWfWorkflowRoute.getSimpleStore(long.Parse(this.Request.QueryString["stepId"])));
        script.Append("\r\n");

        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = this.Request.QueryString["method"];
        switch (method)
        {
            case "getcondition":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStepCondition.getCondition(this);
                break;
            case "addcondition":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStepCondition.addCondition(this);
                break;
            case "editcondition":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStepCondition.editCondition(this);
                break;
            case "delcondition":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStepCondition.deleteCondition(this);
                break;
            case "getconditionlist":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStepCondition.getConditionList(this);
                break;
            case"getorgtreelist":
                ZJSIG.UIProcess.ADM.UIAdmOrg.getCurrentAndChildrenTree(this);
                break;
            case"getDtlList":
                ZJSIG.UIProcess.ADM.UIWfWorkflowStepCondition.getConditionAndList( this );
                break;
        }
    }
}
