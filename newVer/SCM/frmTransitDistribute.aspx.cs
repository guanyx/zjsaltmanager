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
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.BA;

public partial class SCM_frmTransitDistribute : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取组织
        script.Append( "var dsOrgList = " );  //这个变量名界面combobox需要使用，保持一致
        script.Append( ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getOrgListStore( this ) );

        //发运单状态
        script.Append( "var dsStatus = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( CommonDefinition.SCM_PROVIDE_SEND_TYPE ) );

        //获取商品列表
        script.Append( "\r\n" );
        script.Append( "var dsProductList = " );
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
     
        method = Request.QueryString[ "method" ];
        switch ( method )
        {
            case "addTransmitDistribute":
                ZJSIG.UIProcess.SCM.UIScmNoticeMst.saveTransmitData( this );
                break;
            case "getProvideSendDtl":
                ZJSIG.UIProcess.SCM.UIScmNoticeMst.getProvideSendDtlList( this );
                break;
            case "getTransmitDtlList":
                ZJSIG.UIProcess.SCM.UIScmNoticeMst.getStaticDtlList( this );
                break;
            case "comfirmTransmitData":
                ZJSIG.UIProcess.SCM.UIScmNoticeMst.confirmTransmitData( this );
                break;
            case "getOrgBydestination":
                ZJSIG.UIProcess.SCM.UIScmOrgDestinationCfg.GetOrgByDestinationsStore( this );
                break;
            case "getSettlePrice":
                ZJSIG.UIProcess.SCM.UIScmNoticeMst.getSettlePrice( this );
                break;
        }
    }
}
