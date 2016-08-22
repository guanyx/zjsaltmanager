using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Text;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class BA_sysadmin_frmAdmStaticReportDesign : System.Web.UI.Page
{

    protected string getComboBoxSource( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        //获取公司类别信息
        script.Append( "var ReportTypeStore =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "A01" ) );


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
            case "getreportlist":
                ZJSIG.UIProcess.ADM.UIAdmStaticReport.getReportList( this );
                break;
            //新增机构信息
            case "add":
                ZJSIG.UIProcess.ADM.UIAdmStaticReport.addReport( this );
                break;
            //获取机构信息
            case "getreport":
                ZJSIG.UIProcess.ADM.UIAdmStaticReport.getReport( this );
                break;
            //删除机构信息
            case "deleteReport":
                ZJSIG.UIProcess.ADM.UIAdmStaticReport.deleteReport( this );
                break;
            //编辑机构信息
            case "edit":
                ZJSIG.UIProcess.ADM.UIAdmStaticReport.editReport( this );
                break;
            case"getheaderlist":
                ZJSIG.UIProcess.ADM.UIAdmStaticReport.getReportHeaderList( this );
                break;
            case"getviewcolumn":
                ZJSIG.UIProcess.ADM.UIAdmStaticReport.getViewColumn( this );
                break;
        }
    }
}
