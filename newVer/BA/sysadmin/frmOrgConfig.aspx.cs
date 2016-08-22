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

public partial class BA_sysadmin_frmOrgConfig : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        script.Append( "\r\n" );
        script.Append( "var storeConfig = " + StoreFilter.ToString( ).ToLower() + ";" );
        script.Append( "\r\n" );
        script.Append( "var saleConfig = " + SaleStoreFilter.ToString( ).ToLower() + ";" );
        script.Append( "\r\n" );
        script.Append( "var saleStore = " + SaleCanSeeStore.ToString( ).ToLower() + ";" );
        script.Append( "\r\n" );
        script.Append( "var customerServer = " + CustomerServer.ToString( ).ToLower( ) + ";" );
        script.Append( "\r\n" );
        script.AppendLine( "var autoSplitPurch = " + AutoSplitPurch.ToString( ).ToLower( ) + ";" );
        script.AppendLine( "var autoSumqtyForSalerpt = " + AutoSumqtyForSalerpt.ToString( ).ToLower( ) + ";" );
        script.AppendLine( " var checkDate = '" + CheckDate.ToShortDateString( ) + "';" );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "saveconfig":
                ZJSIG.UIProcess.UIMessageBase message = new ZJSIG.UIProcess.UIMessageBase( );
                try
                {
                    string saleConfig = this.Request[ "SaleConfig" ];
                    string storeConfig = this.Request[ "StoreConfig" ];
                    string saleStore = this.Request[ "SaleStore" ];
                    string customreServer = this.Request[ "CustomerServer" ];
                    string autoSplitPurch = this.Request[ "AutoSplitPurch" ];
                    string autoSumqtyForSalerpt = this.Request[ "AutoSumqtyForSalerpt" ];
                    string checkDate = this.Request[ "CheckDate" ];
                    if ( saleConfig == "true" )
                    {
                        SaleStoreFilter = true;
                    }
                    else
                    {
                        SaleStoreFilter = false;
                    }
                    if ( storeConfig == "true" )
                    {
                        StoreFilter = true;
                    }
                    else
                    {
                        StoreFilter = false;
                    }
                    if ( saleStore == "true" )
                    {
                        SaleCanSeeStore = true;
                    }
                    else
                        SaleCanSeeStore = false;
                    if ( customreServer == "true" )
                    {
                        CustomerServer = true;
                    }
                    else
                        CustomerServer = false;
                    if ( autoSplitPurch == "true" )
                    {
                        AutoSplitPurch = true;
                    }
                    else
                    {
                        AutoSplitPurch = false;
                    }
                    if ( autoSumqtyForSalerpt == "true" )
                    {
                        AutoSumqtyForSalerpt = true;
                    }
                    else
                    {
                        AutoSumqtyForSalerpt = false;
                    }
                    if ( checkDate != "" )
                    {
                        CheckDate = DateTime.Parse( checkDate);
                    }
                    UpdateConfig( );
                    message.success = true;
                    message.errorinfo = "单位基本业务设置保存成功！";
                }
                catch(Exception ep)
                {
                    message.success = false;
                    message.errorinfo = "单位基本业务设置保存失败！"+ep.Message;
                }
                this.Response.Write( ZJSIG.UIProcess.UIProcessBase.ObjectToJson( message ) );
                this.Response.End( );
                break;
        }
    }
}
