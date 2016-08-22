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

public partial class BA_sysadmin_frmSysMessage : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {

        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //获取组织
        script.Append("var orgId = '" + OrgID.ToString() + "';");

        script.Append("var orgName='" + OrgName + "';");


        script.Append("</script>\r\n");
        return script.ToString();
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
            case "getMessageList":
                ZJSIG.UIProcess.BA.UISysMessage.getMessageList( this );
                break;
            case "getMessage":
                ZJSIG.UIProcess.BA.UISysMessage.getMessage( this ) ;
                break;
            case "saveMessage":
                ZJSIG.UIProcess.BA.UISysMessage.editMessage( this ) ;
                break;
            case "addMessage":
                ZJSIG.UIProcess.BA.UISysMessage.addMessage( this ) ;
                break;
            case "deleteMessage":
                ZJSIG.UIProcess.BA.UISysMessage.deleteMessage( this );
                break;
            default:
                return;
        }
        
    }
}
