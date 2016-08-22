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

public partial class sysadmin_frmAdmRoleList : PageBase
{
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //角色类型5
        script.Append("var RoleTypeStore =");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A01"));

        //非省公司，只能创建子公司角色
        if ( OrgID > 1 )
        {
            script.Append( "var topOrg=false;\r\n" );
        }
        else
        {
            script.Append( "var topOrg=true;\r\n" );
        }
        script.Append( "var childOrgType='A013';\r\n" );
        script.Append("</script>\r\n");
        return script.ToString();
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
                    //获取角色列表信息
                case "getrolelist":
                    ZJSIG.UIProcess.ADM.UIAdmRole.getRoleList(this);
                    break;
                    //新增角色信息
                case "add":
                    ZJSIG.UIProcess.ADM.UIAdmRole.addRole(this);
                    break;
                    //获取角色信息
                case "getrole":
                    ZJSIG.UIProcess.ADM.UIAdmRole.getRole(this);
                    break;
                    //删除角色信息
                case "deleteRole":
                    ZJSIG.UIProcess.ADM.UIAdmRole.deleteRole(this);
                    break;
                    //编辑角色信息
                case "editRole":
                    ZJSIG.UIProcess.ADM.UIAdmRole.editRole(this);
                    break;
            }
    }
}
