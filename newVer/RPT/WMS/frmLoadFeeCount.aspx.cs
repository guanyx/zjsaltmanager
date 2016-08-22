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
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.RPT;
using System.Text;

public partial class RPT_WMS_frmLoadFeeStatics : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取装卸公司
        script.Append( "\r\n" );
        script.Append( "var dsCompanyList = " );
        script.Append( UIWmsLoadCompany.getCompanyListStore(this ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlist":
                UITansLoadFee.getViewListForRPT( this );
                break;
        }
    }
}
