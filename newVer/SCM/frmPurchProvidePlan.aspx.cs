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
using ZJSIG.UIProcess.Common;

public partial class SCM_frmPurchProvidePlan : PageBase
{
    public string getComboBoxSource( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        script.Append( "var imageUrl = \"../Theme/1/\";\r\n" );
        script.Append( "var planId='" + this.Request.QueryString[ "PlanId" ] + "';\r\n" );
        //创建toolbar信息
        script.Append( initToolBar( ) );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    private string initToolBar( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "function iniToolBar(Toolbar)\r\n" );
        script.Append( "{\r\n" );

        string iconUrl = "imageUrl + \"images/extjs/customer/{0}\"";
        ToolBarButton tb = null;
        switch ( Action )
        {
            //创建供应商的要货单
            case "message":
                tb = new ToolBarButton( "addNew", "新增要货单", string.Format( iconUrl, "'add16.gif'" ), "Toolbar" );
                script.Append( tb.createButton( ) );
                break;
            default:
                script.Append( new ToolBarButton( "groupCustomerName", "按供应商分组", "'add16.gif'", "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "groupProductName", "按产品分组", "'add16.gif'", "Toolbar" ).createButton( ) );
                break;
        }
        script.Append( "Toolbar.render();\r\n" );
        script.Append( "}\r\n" );
        return script.ToString( );
    }


    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case"getdtllist":
                ZJSIG.UIProcess.SCM.UIScmPurch.getScmPurchProvidePlanListByPlanId( this );
                break;
        }
    }
}
