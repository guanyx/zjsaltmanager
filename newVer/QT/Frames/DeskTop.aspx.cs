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

public partial class QT_Frames_DeskTop : PageBase
{
    public string LoginName = "";
    public string LoginDepart = "";
    public string LoginOrg = "";
    public string UserName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ZJSIG.ADM.BusinessEntities.AdmDept o = ZJSIG.ADM.BLL.BLAdmDept.GetModel(DeptID);
            LoginDepart = o == null ? "" : o.DeptName;
            LoginName = ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeName(this);
            LoginOrg = ZJSIG.UIProcess.ADM.UIAdmUser.OrgName(this);
            UserName = ZJSIG.UIProcess.ADM.UIAdmUser.UserName(this);
        }
        catch (Exception ex)
        {

        }
    }
}
