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
using ZJSIG.UIProcess.FM;
using System.Text;

public partial class FM_frmFmAccPayCfg : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //付款类型
        script.Append( "var dsAlert = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "F10" ) );


        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = Request.QueryString[ "method" ];

        switch ( method )
        {
            case "addCfg":
                UIFmAccountsPayableCfg.addCfg( this );
                break;
            case "saveCfg":
                UIFmAccountsPayableCfg.editCfg( this );
                break;
            case "deleteCfg":
                UIFmAccountsPayableCfg.deleteCfg( this );
                break;
            case "getCfg":
                UIFmAccountsPayableCfg.getCfg( this );
                break;
            case "getCfgList":
                UIFmAccountsPayableCfg.getCfgList( this );
                break;
        }
    }
}
