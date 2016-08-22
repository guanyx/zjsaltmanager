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

public partial class BA_sysadmin_frmAdmDocReportCreate : System.Web.UI.Page
{
    protected string GetScript( )
    {
        StringBuilder script = new StringBuilder( );
        string reportId = this.Request.QueryString[ "ReprotId" ];
        if ( reportId == null )
            reportId = "0";
        script.Append( "<script>\r\n" );
        script.Append( "var reportId="+reportId+";\r\n" );
        script.Append( "</script>" );
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
            case "getbookmark":
                ZJSIG.UIProcess.ADM.UIAdmDocReport.getBookMark( this );
                break;
            //新增机构信息
            case "getmuldetail":
                ZJSIG.UIProcess.ADM.UIAdmDocReport.getMulDetail( this );
                break;
            //获取机构信息
            case "getmuldetailcolumn":
                ZJSIG.UIProcess.ADM.UIAdmDocReport.getMulDetailColumn( this );
                break;
            //删除机构信息
            case "getdocreport":
                ZJSIG.UIProcess.ADM.UIAdmDocReport.getDocReport( this );
                break;
            //编辑机构信息
            case "savedoc":
                ZJSIG.UIProcess.ADM.UIAdmDocReport.saveDocReport( this );
                break;
            case"getdocreportlist":
                ZJSIG.UIProcess.ADM.UIAdmDocReport.getDocReportList( this );
                break;
            case"deletedoc":
                ZJSIG.UIProcess.ADM.UIAdmDocReport.deleteDocReport( this );
                break;
        }
    }
}
