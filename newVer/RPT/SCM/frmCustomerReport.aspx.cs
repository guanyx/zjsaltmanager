using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;

public partial class RPT_SCM_frmCustomerReport : System.Web.UI.Page
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //所属行业
        script.Append( "var dsTradeType =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_TRADETYPE ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = Request.QueryString[ "method" ];
        if ( "getlist".Equals( method ) )
        {
            ZJSIG.UIProcess.Report.CustomerSaleReport.getCustomerSaleReport( this );
        }
        else if ("exportData".Equals(method))
        {
            ZJSIG.UIProcess.RPT.SCM.UIExportFile.ExportCustomerSaleReport(this);
        }
    }
}
