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
using ZJSIG.UIProcess.RPT.SCM;
using System.Text;
using ZJSIG.UIProcess.ADM;

public partial class RPT_SCM_frmAccountUnitProductStat : PageBase
{
    
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        script.Append("\r\n");
        script.Append("var orgId = '" + OrgID.ToString() + "';");
        script.Append("\r\n");
        script.Append("var orgName = '" + OrgName + "';");

        //组织
        //script.Append( "\r\n" );
        //script.Append( "var dsOrgList = " );
        //script.Append( UIAdmOrg.getOrgListStore(this ) );

        //领货单状态 
        script.Append( "\r\n" );
        script.Append( "var dsStatusList = new Ext.data.SimpleStore({" );
        script.Append("fields:['DicsCode','DicsName'],");
        script.Append( "data: [[3,\"待出库\"],[4,\"仓库出库\"],[5,\"到货确认\"]]," );
        script.Append( "dautoLoad: false}); " );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlist":
                UIAccountUnitProductStat.getViewList( this );
                break;
            case "getgroupby":
                ZJSIG.UIProcess.UIProcessBase.GetGroupStore( this, "v_scm_Draw_MstAndDtl" );
                break;
        }
    }
}
