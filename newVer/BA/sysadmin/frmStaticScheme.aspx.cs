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

public partial class BA_sysadmin_frmStaticScheme : System.Web.UI.Page
{
    protected string getComboBoxSource( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        string reportId = this.Request.QueryString[ "reportId" ];
        if ( reportId == null || reportId == "" )
        {
            //获取部门类型信息
            script.AppendLine( "var reportId='0';" );
            script.AppendLine( "var viewName='';" );
        }
        else
        {
            //获取部门类型信息
            script.AppendLine( "var reportId='" + this.Request.QueryString[ "reportId" ] + "';" );
            script.AppendLine( "var viewName='" + this.Request.QueryString[ "viewName" ] + "';" );
        }

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
            case "getschemelist":
                ZJSIG.UIProcess.ADM.UIAdmStaticScheme.getSchemeList( this );
                break;
            //新增机构信息
            case "addscheme":
                ZJSIG.UIProcess.ADM.UIAdmStaticScheme.addScheme( this );
                break;
            //获取机构信息
            case "getscheme":
                ZJSIG.UIProcess.ADM.UIAdmStaticScheme.getScheme( this );
                break;
            //删除机构信息
            case "deletscheme":
                ZJSIG.UIProcess.ADM.UIAdmStaticScheme.deleteScheme( this );
                break;
            //编辑机构信息
            case "editscheme":
                ZJSIG.UIProcess.ADM.UIAdmStaticScheme.editScheme( this );
                break;
            case"getschemedtllist":
                ZJSIG.UIProcess.ADM.UIAdmStaticScheme.getSchemeDtlList( this );
                break;
        }
    }
}
