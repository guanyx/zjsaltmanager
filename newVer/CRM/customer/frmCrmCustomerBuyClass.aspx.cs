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
using ZJSIG.UIProcess.CRM;

public partial class CRM_customer_frmCrmCustomerBuyClass : PageBase
{
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
            case "getClassInfoList":
                //查询所有客户存货分类信息
                UICrmCustomerBuyClass.getClassList( this );
                break;
            case "deleteClasses":
                //循环删除客户存货分类信息
                UICrmCustomerBuyClass.deleteClass( this );
                break;
            case "getClasseInfo":
                //获取一条信息
                UICrmCustomerBuyClass.getClass( this );
                break;
            case "saveClassInfo":
                //单个保存
                UICrmCustomerBuyClass.editClass( this );
                break;
            case "addClassInfo":
                //单个增加
                UICrmCustomerBuyClass.addClass( this );
                break;
            case "getProducts": //得到该分类下的商品
                UICrmCustomerBuyClass.getYetProducts( this );
                break;
            case "getNonProducts":
                UICrmCustomerBuyClass.getNonProducts( this );
                break;
            case "deleteProductInfos"://删除该分类下的商品
                UICrmCustomerBuyClass.deleteProductInfo( this );
                break;
            case "saveProductInfos":
                UICrmCustomerBuyClass.saveClassProductInfo( this );
                break;
        }
    }
}
