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
using ZJSIG.UIProcess.CRM;
using System.Text;

public partial class CRM_customer_frmCrmCustomerIndicator : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获企业性质
        script.Append( "var dsEmployee =" );
        script.Append( ZJSIG.UIProcess.ADM.UIAdmEmployee.getEmployeeListStore(this) );

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
            case "getIndicatorList":
                UIBusinessCrmCustomerIndicator.getIndicatorList( this );
                break;
            case "deleteIndicator":
                UIBusinessCrmCustomerIndicator.deleteIndicator( this );
                break;
            case "getIndicator":
                UIBusinessCrmCustomerIndicator.getIndicator( this );
                break;
            case "saveIndicator":
                UIBusinessCrmCustomerIndicator.editIndicator( this );
                break;
            case "addIndicator":
                UIBusinessCrmCustomerIndicator.addIndicator( this );
                break;

        }
    }
}
