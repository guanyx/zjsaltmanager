using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Text;

public partial class BA_sysadmin_frmRoleResource : System.Web.UI.Page
{
    public string RoleIDScript
    {
        get
        {
            StringBuilder script = new StringBuilder();
            script.Append("<script>\r\n");
            script.Append(string.Format("var roleID = '{0}';\r\n", this.Request.QueryString["roleid"]));
            script.Append("</script>\r\n");
            return script.ToString();
        }
    }
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
            
            case "gettreelist":
                //string data = "[{\"cls\":\"folder\",\"id\":10,\"leaf\":false,checked:false,\"children\":[{\"cls\":\"file\",\"id\":11,\"leaf\":true,checked:false,\"children\":null,\"text\":\"S600\"},{\"cls\":\"file\",\"id\":12,\"leaf\":true,checked:false,\"children\":null,\"text\":\"SLK200\"}],\"text\":\"Benz\"}]";
                //this.Response.Write(data);
                //this.Response.End();
                //string data = "[{cls:'folder',id:'5',leaf:false,children:[{cls:'folder',id:'6',leaf:true,children:null,text:'用户管理',checked:false}],text:'系统管理',checked:false}]";
                //this.Response.Write(data);
                //this.Response.End();
                ZJSIG.UIProcess.ADM.UIAdmResource.getResourceTreeList(this);
                break;
            case"saveresources":
                ZJSIG.UIProcess.ADM.UIAdmResource.saveRoleResources(this);
                break;
        }
    }
}
