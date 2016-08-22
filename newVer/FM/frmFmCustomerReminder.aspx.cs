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
using System.Text;

public partial class FM_frmFmCustomerReminder : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //类型
        script.Append( "var dsReminderType = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "F07" ) );

        //状态
        script.Append( "var dsStatus = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "F08" ) );


        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString[ "method" ];
            switch ( method )
            {
                case "addReminder":
                    ZJSIG.UIProcess.FM.UIVFmCustomerReminder.addReminder( this );
                    break;
                case "saveReminder":
                    ZJSIG.UIProcess.FM.UIVFmCustomerReminder.editReminder( this );
                    break;
                case "getReminder":
                    ZJSIG.UIProcess.FM.UIVFmCustomerReminder.getReminder( this );
                    break;
                case "getReminderList":
                    ZJSIG.UIProcess.FM.UIVFmCustomerReminder.getReminderList( this );
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
