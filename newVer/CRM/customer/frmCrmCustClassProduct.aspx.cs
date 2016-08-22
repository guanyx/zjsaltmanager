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

public partial class CRM_customer_frmCrmCustClassProduct : PageBase
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string strCustomerId = "";
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
            case "gettreelist":
                ZJSIG.UIProcess.CRM.UICrmCustomerClassProduct.getCrmCustomreBuyClassTreeList( this );
                break;
            case "getCustomers":
                //获取所有客户信息（接受传入条件）
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getCustomerList( this );
                break;
                break;
            case "getProducts":
                //得到所有已经属于该客户的该分类下的产品
                ZJSIG.UIProcess.CRM.UICrmCustomerClassProduct.getYetProducts( this );
                break;
            case "getNonProducts":
                //得到所有为添加到该类别的商品(暂时选择所有商品)
                ZJSIG.UIProcess.CRM.UICrmCustomerClassProduct.getNonProducts( this );
                break;
            case "saveProductInfos":
                //保存多选的产品到客户的分类下面
                break;
            case "deleteProductInfos":
                //删除多选的客户分类下的产品
                break;
        }
    }
}
