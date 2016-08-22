using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BA_sysadmin_frmWfSetColumnList : System.Web.UI.Page
{
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取部门类型信息
        script.Append("var stepId ='");
        script.Append(this.Request.QueryString["stepId"]);
        script.Append("';\r\n");


        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = this.Request.QueryString["method"];
        switch (method)
        {
            case "getsetcolumn":
                ZJSIG.UIProcess.ADM.UIWfWorkflowSetphycolumn.getSetphycolumn(this);
                break;
            case "addsetcolumn":
                ZJSIG.UIProcess.ADM.UIWfWorkflowSetphycolumn.addSetphycolumn(this);
                break;
            case "editsetcolumn":
                ZJSIG.UIProcess.ADM.UIWfWorkflowSetphycolumn.editSetphycolumn(this);
                break;
            case "delsetcolumn":
                ZJSIG.UIProcess.ADM.UIWfWorkflowSetphycolumn.deleteSetphycolumn(this);
                break;
            case "getsetcolumnlist":
                ZJSIG.UIProcess.ADM.UIWfWorkflowSetphycolumn.getSetphycolumnList(this);
                break;
        }
    }
}
