using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class CRM_product_frmCrmCustomerFixPrice : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

    /*
        //获取产地
        script.Append( "var dsOrigin =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "B02" ) );

        //获取计价方法
        script.Append( "var dsAliasPrice =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "B03" ) );

        //获取计价方法
        script.Append( "var dsProductType =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "B04" ) );

        //获取单位
        script.Append( "var dsUnit =" );
        script.Append( ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore( ) );
        */
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch ( Exception ex )
        {
        }

        switch ( method )
        {
            case "getFixpiceList":
                ZJSIG.UIProcess.CRM.UICrmCustomerFixpice.getFixpiceList( this );
                break;
            case "getfixpice":
                ZJSIG.UIProcess.CRM.UICrmCustomerFixpice.getFixpiceView( this );
                break;
            case "saveFixpice":
                ZJSIG.UIProcess.CRM.UICrmCustomerFixpice.editFixpice( this );
                break;
            case "addFixpice":
                ZJSIG.UIProcess.CRM.UICrmCustomerFixpice.addFixpice( this );
                break;
            case "deleteFixpice":
                ZJSIG.UIProcess.CRM.UICrmCustomerFixpice.deleteFixpice( this );
                break;
            case "getProducts":
                ZJSIG.UIProcess.BA.UIBaProduct.getProductListForDropDownList( this );
                break;
            case "getCustomers":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getCustomerListForDropDownList( this );
                break;
            default:
                return;
        }
    }
}
