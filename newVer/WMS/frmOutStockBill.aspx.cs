using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.CRM;

public partial class WMS_frmOutStockBill : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        //string strId = Request.QueryString["id"];
        //bool isEdit = (strId != null && strId.Trim().Length > 0) ? true : false;
        StringBuilder script = new StringBuilder();
        //获取仓库
        script.Append("<script>\r\n");
        script.Append("var dsWarehouseList = ");
        script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        ////获取规格
        script.Append("\r\n");
        script.Append("var dsProductSpecList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("B01"));
        //获取商品单位
        script.Append("\r\n");
        script.Append("var dsProductUnitList = ");
        script.Append(UIBaProductUnit.getUnitInfoStore());
        //获取商品列表
        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append( UIBaProduct.getProductListInfoStore( this ) );
        //装卸公司
        script.Append("\r\n");
        script.Append("var dsLoadCompanyList = ");
        script.Append(UIWmsLoadCompany.getCompanyListStore(this));

        //单据类型
        script.Append("\r\n");
        script.Append("var dsBillTypeList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W02"));
        //供应商
        script.Append("\r\n");
        script.Append("var dsSuppliesListInfo = ");
        script.Append(UIBusinessCrmCustomer.getSuppliesListInfoStore());

        script.Append("</script>\r\n");
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch
        {
        }

        switch (method)
        {
            case "getWarehousePosList":
                UIWmsWarehousePosition.getWarehousePositionListByWhId(this);
                break;
            case "getPurchaseOrderInfo":
                UIWmsPurchaseOrder.getOrder(this);
                break;
            case "getPurchaseOrderListInfo":
                UIWmsPurchaseOrderDetail.getDetailList(this);
                break;
            case "getInStockProductDetailInfo"://进仓商品明细列表
                UIWmsStockInoutDetail.getDetailList(this);
                break;
            case "getInStockBillInfo":
                UIWmsStockInout.getInoutList(this);
                break;
            case "SaveInStockOrder":
                UIWmsStockInout.saveOrder(this);
                break;
        }
    }
}
