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
using ZJSIG.UIProcess.BA;

public partial class PMS_frmPmsAuxGdsRecord : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //车间列表
        script.Append( "var dsWs = " );
        script.Append( ZJSIG.UIProcess.PMS.UIPmsWorkshop.getWorkshopListStore( this ) );

        //获取商品列表(应该是供应商下面的小类，这里应该管理进去供应商)
        script.Append( "\r\n" );
        script.Append( "var dsProductList = " );
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

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
            case "addRecord":
                ZJSIG.UIProcess.PMS.UIPmsAuxGdsRecord.addRecord( this );
                break;
            case "saveRecord":
                ZJSIG.UIProcess.PMS.UIPmsAuxGdsRecord.editRecord( this );
                break;
            case "deleteRecord":
                ZJSIG.UIProcess.PMS.UIPmsAuxGdsRecord.deleteRecord( this );
                break;
            case "getrecord":
                ZJSIG.UIProcess.PMS.UIPmsAuxGdsRecord.getRecord( this );
                break;
            case "getrecordList":
                ZJSIG.UIProcess.PMS.UIPmsAuxGdsRecord.getRecordList( this );
                break;
        }
    }
}
