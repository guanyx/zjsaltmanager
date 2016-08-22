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
using ZJSIG.UIProcess.SCM;
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.CRM;
using ZJSIG.UIProcess.WMS;
using System.Text;

public partial class SCM_frmScmRebateOrder : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {

        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

 
        //获取仓库列表
        script.Append("var dsWareHouse = ");
        script.Append(ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStoreByEmpId(this));


        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                case "getOrderList":
                    UIScmRebateOrder.getOrderList(this);
                    break;
                case "deleteOrder":
                    UIScmRebateOrder.deleteOrder(this);
                    break;
                case "confirmOrder":
                    UIScmRebateOrder.confirmOrder(this);
                    break;
                case "saveOrder":
                    UIScmRebateOrder.saveOrder(this);
                    break;
                case "getOrder":
                    UIScmRebateOrder.getOrder(this);
                    break;
                case "getProductUnits":
                    UIBaProduct.getProductUnitsStore(this);
                    break;
                case "getCustomProduct":
                    //当前客户可订商品列表
                    UIScmOrderDtl.getCustomProduct(this);
                    break;
                case "getProductByNameNo":
                    UIBaProduct.getProductListByNameAndNo(this);
                    break;
                case "getProductInfo":
                    UICrmCustomerFixpice.getProductByNoForSCM(this);
                    break;
                case "getDtlList":
                    UIScmRebateOrderDtl.getDetailList(this);
                    break;
                case "getCusByConLike"://得到客户或供应商列表
                    string busiType = this.Request.Form["BusinessType"];
                    if (busiType == "S321")
                        UIBusinessCrmCustomer.getSaleCustomerListForDropDownList(this);
                    else
                        UIBusinessCrmCustomer.getSuppilerAndInnerCustomerListForDropDownList(this);
                    break;
                case "getWarehousePosList":
                    UIWmsWarehousePosition.getWarehousePositionListByWhId(this);
                    break;

                default:
                    break;                
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
