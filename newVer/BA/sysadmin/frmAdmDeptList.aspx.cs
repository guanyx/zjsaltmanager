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
using System.Text;

public partial class BA_sysadmin_frmAdmDeptList :PageBase
{

    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取部门类型信息
        script.Append("var DeptTypeStore =");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A08"));

        
        script.Append("</script>\r\n");
        return script.ToString();
    }

    public string OrgInformation
    {
        get
        {
            long orgID = 0;
            //首先查找是否有传递过来的机构信息
            long.TryParse(this.Request.QueryString["orgid"], out orgID);
            if (orgID == 0)
            {
                //如果没有就获取默认登录ID信息
                orgID = OrgID;
            }
            string orgName = ZJSIG.UIProcess.ADM.UIAdmOrg.getOrgNameById(orgID);
            return string.Format("<script>\r\n var orgId = {0};\r\n var orgName='{1}';\r\n </script>\r\n", orgID, orgName);
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
            //获取机构列表信息
            case "getlist":
                ZJSIG.UIProcess.ADM.UIAdmDept.getDeptList(this);
                break;
            //新增机构信息
            case "add":
                ZJSIG.UIProcess.ADM.UIAdmDept.addDept(this);
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
            case"gettreecolumnlist":
                ZJSIG.UIProcess.ADM.UIAdmDept.getTreeColumnList( this );
                break;
        }
    }
}
