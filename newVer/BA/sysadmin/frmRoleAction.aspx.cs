using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class BA_sysadmin_frmRoleAction : System.Web.UI.Page
{
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取数据权限
        script.Append("var purviewStore =");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A02"));

        script.Append("var roleid='"+this.Request.QueryString["roleid"]+"';\r\n");
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
            //获取机构列表信息
            case "getactionlist":
                ZJSIG.UIProcess.ADM.UIAdmRole.getRoleResourceActionList(this);
                break;
            //新增机构信息
            case "saveroleaction":
                ZJSIG.UIProcess.ADM.UIAdmRole.saveRoleAction(this);
                break;
            //获取机构信息
            case "getdept":
                ZJSIG.UIProcess.ADM.UIAdmDept.getDept(this);
                break;
            //删除机构信息
            case "deletedept":
                ZJSIG.UIProcess.ADM.UIAdmDept.deleteDept(this);
                break;
            //编辑机构信息
            case "editdept":
                ZJSIG.UIProcess.ADM.UIAdmDept.editDept(this);
                break;
        }
    }
}
