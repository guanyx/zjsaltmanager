using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class FM_frmFmFundAssemble : PageBase
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
        script.Append( "\r\n" );
        script.Append( "var orgId = '" + OrgID.ToString( ) + "';" );
        script.Append( "\r\n" );
        script.Append( "var orgName = '" + OrgName + "';" );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }


    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
            method = Request.QueryString["method"];
            switch ( method )
            {
                case "getReceivelist":
                    ZJSIG.UIProcess.FM.UIFmAccountRece.getAccountReceList(this);
                    break;
                case "getlist":
                    ZJSIG.UIProcess.FM.UIFmFundAssembleRel.getRelList(this);
                    break;
                case "getRelList":
                    ZJSIG.UIProcess.FM.UIFmFundAssemble.getAssembleListStore(this);
                    break;
                case "saveData":
                    ZJSIG.UIProcess.FM.UIFmFundAssemble.editAssemble(this);
                    break;
                case "deteleData":
                    ZJSIG.UIProcess.FM.UIFmFundAssemble.deleteAssemble(this);
                    break;
                case "exportData":
                    ZJSIG.UIProcess.FM.UIFmFundAssemble.exportData(this);
                    break;
            }
    }
}
