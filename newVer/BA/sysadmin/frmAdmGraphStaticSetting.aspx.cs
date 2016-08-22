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

public partial class BA_sysadmin_frmAdmGraphStaticSetting : System.Web.UI.Page
{
    protected string getComboBoxSource( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        //获取部门类型信息
        script.AppendLine( "var schemeId='" + this.Request.QueryString[ "schemeId" ] + "';" );
        
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

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
            case "getgraphlist":
                ZJSIG.UIProcess.ADM.UIAdmStaticScheme.getSchemeGraphList( this );
                break;
            case"save":
                ZJSIG.UIProcess.ADM.UIAdmStaticScheme.saveGraphList( this );
                break;
            
        }
    }
}
