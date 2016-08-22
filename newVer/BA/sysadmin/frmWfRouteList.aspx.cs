using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BA_sysadmin_frmWfRouteList : System.Web.UI.Page
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
            case "getroute":
                ZJSIG.UIProcess.ADM.UIWfWorkflowRoute.getRoute(this);
                break;
            case "addroute":
                ZJSIG.UIProcess.ADM.UIWfWorkflowRoute.addRoute(this);
                break;
            case "editroute":
                ZJSIG.UIProcess.ADM.UIWfWorkflowRoute.editRoute(this);
                break;
            case "delroute":
                ZJSIG.UIProcess.ADM.UIWfWorkflowRoute.deleteRoute(this);
                break;
            case "getroutelist":
                ZJSIG.UIProcess.ADM.UIWfWorkflowRoute.getRouteList(this);
                break;
        }
    }
}
