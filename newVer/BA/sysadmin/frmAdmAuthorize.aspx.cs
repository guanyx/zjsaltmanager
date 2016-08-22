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

public partial class BA_sysadmin_frmAdmAuthorize : System.Web.UI.Page
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString[ "method" ];
        }
        catch ( Exception ex )
        {
        }
        switch ( method )
        {
            //获取机构列表信息
            case "getauthorlist":
                ZJSIG.UIProcess.ADM.UIAdmAuthorization.getAuthorizationList( this );
                break;
            //新增机构信息
            case "add":
                ZJSIG.UIProcess.ADM.UIAdmAuthorization.addAuthorization( this );
                break;
            //获取机构信息
            case "getauthor":
                ZJSIG.UIProcess.ADM.UIAdmAuthorization.getAuthorization( this );
                break;
            //删除机构信息
            case "deleteauthor":
                ZJSIG.UIProcess.ADM.UIAdmAuthorization.deleteAuthorization( this );
                break;
            //编辑机构信息
            case "editauthor":
                ZJSIG.UIProcess.ADM.UIAdmAuthorization.editAuthorization( this );
                break;
            case"getresource":
                ZJSIG.UIProcess.ADM.UIAdmAuthorization.getUserResourceTree( this );
                break;
            case"gettreecolumnlist":
                ZJSIG.UIProcess.ADM.UIAdmEmployee.getOrgDeptEmpTreeStore( this );
                break;
            case"stopauthor":
                ZJSIG.UIProcess.ADM.UIAdmAuthorization.stopAuthorization( this );
                break;
        }
    }
}
