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
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.RPT.SCM;

public partial class RPT_SCM_frmAccountUnitDrawStat : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //组织
        //script.Append( "\r\n" );
        //script.Append( "var dsOrgList = " );
        //script.Append( UIAdmOrg.getOrgListStore( this ) );

        //组织
        script.Append("\r\n");
        script.Append("var orgId = '" + OrgID.ToString() + "';");
        script.Append("\r\n");
        script.Append("var orgName = '" + OrgName + "';");

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlist":
                UIAccountUnitDrawStat.getViewList( this );
                break;
            case "getgroupby":
                ZJSIG.UIProcess.UIProcessBase.GetGroupStore( this,"VScmOrdermst" );
                break;
        }
    }
}
