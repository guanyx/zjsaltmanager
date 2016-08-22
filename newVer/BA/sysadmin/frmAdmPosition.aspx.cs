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

public partial class BA_sysadmin_frmAdmPosition : PageBase
{
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取部门类型信息
        //script.Append("var DeptTypeStore =");
        //script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A08"));
        script.Append( "var DeptStore=" );
        script.Append( ZJSIG.UIProcess.ADM.UIAdmDept.getDeptSimpleStore( OrgID ) );

        script.Append( "var typeStore=" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "A21" ) );

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

    protected void Page_Load( object sender, EventArgs e )
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
                ZJSIG.UIProcess.ADM.UIAdmPosition.getPositionList(this);
                break;
            //新增机构信息
            case "add":
                ZJSIG.UIProcess.ADM.UIAdmPosition.addPosition(this);
                break;
            //获取机构信息
            case "getposition":
                ZJSIG.UIProcess.ADM.UIAdmPosition.getPosition(this);
                break;
            //删除机构信息
            case "deleteposition":
                ZJSIG.UIProcess.ADM.UIAdmPosition.deletePosition(this);
                break;
            //编辑机构信息
            case "editposition":
                ZJSIG.UIProcess.ADM.UIAdmPosition.editPosition(this);
                break;
            case"getorgdepttree":
                ZJSIG.UIProcess.ADM.UIAdmDept.getOrgDeptTreeStore(this);
                break;
            case"getPositionRoute":
                ZJSIG.UIProcess.ADM.UIAdmPosition.getLineTreeToPosition( this );
                break;
            case"savePositionRoute":
                ZJSIG.UIProcess.ADM.UIAdmPosition.saveLineToPosition( this );
                break;
        }
    }
}
