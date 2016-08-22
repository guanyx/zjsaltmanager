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
using ZJSIG.Common.DataSearchCondition;

public partial class PMS_frmPmsStockOrder : PageBase
{
    protected string getComboBox( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "purch", Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmPrintset";
        System.Data.DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
        if ( ds.Tables[ 0 ].Rows.Count > 0 )
        {
            DataRow dr = ds.Tables[ 0 ].Rows[ 0 ];
            script.Append( "var printStyleXml = '" + dr[ "PrintStyleXml" ].ToString( ) + "';\r\n" );
            script.Append( "var printPageWidth =" + dr[ "PrintPageWidth" ].ToString( ) + ";\r\n" );
            script.Append( "var printPageHeight =" + dr[ "PrintPageHeight" ].ToString( ) + ";\r\n" );
            if ( dr[ "PrintOnlyData" ].ToString( ) == "1" )
            {
                script.Append( "var printOnlyData = true;\r\n" );
            }
            else
            {
                script.Append( "var printOnlyData = false;\r\n" );
            }
        }
        else
        {
            script.Append( "var printStyleXml = 'jspmsorderprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =355;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }
        script.Append( "</script>\r\n" );
        return script.ToString();
    }
    protected void Page_Load( object sender, EventArgs e )
    {

    }
}
