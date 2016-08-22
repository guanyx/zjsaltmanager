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
using ZJSIG.UIProcess.Common;

public partial class SCM_frmProvideSendStatics : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //发运单状态
        script.Append( "var dsStatus = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( CommonDefinition.SCM_PROVIDE_SEND_TYPE) );
       
        //到货通知单状态
        script.Append( "var dsNoticeStatus = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( CommonDefinition.SCM_NOTICE_TYPE ) );

        //获取商品列表(管理进去供应商)
        script.Append("\r\n");
        script.Append("var dsSupplier = ");
        //script.Append( ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSuppliesListInfoStore( this ) );
        script.Append(ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSuppliesListInfoStore(1));

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
            switch ( method )
            {
                case "getProvideSendList"://这里应该添加登录供应商的id来过滤
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.getMstList( this );
                    break;
                case "getconfirmStaticList":
                    ZJSIG.UIProcess.SCM.UIScmNoticeMst.getStaticDtlList( this );
                    break;
                case "finisProvideSend":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.finisProvideSend( this );
                    break;
                case "getProvideSendDtl":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.getDtlList( this );
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
