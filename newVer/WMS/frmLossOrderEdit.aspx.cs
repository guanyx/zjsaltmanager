using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.ADM;
using System.Text;

public partial class WMS_frmLossOrderEdit :PageBase
{
    
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        string strId = Request.QueryString["id"];
        bool isEdit = (strId != null && strId.Trim().Length > 0) ? true : false;
        StringBuilder script = new StringBuilder();

        script.Append("<script>\r\n");
        script.Append("var dsWarehouseList = ");
        //script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));
        script.Append(UIWmsWarehouse.getWarehouseListInfoStoreByEmpId(this));//允许战备盐做损耗

        script.Append("\r\n");
        script.Append("var dsProductSpecList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("B01"));


        script.Append("\r\n");
        script.Append("var dsLossTypeList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W02"));

        script.Append("\r\n");
        script.Append("var dsProductUnitList = ");
        script.Append(UIBaProductUnit.getUnitInfoStore());

        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append( UIBaProduct.getProductListInfoStore( this ) );
        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));

        script.Append("var operId = " + this.EmployeeID.ToString() + ";\r\n");
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

            case "saveLossOrderInfo":
                UIWmsLossOrder.saveOrder(this);
                break;
            case "sendCenterByForm":
                UIWmsLossOrder.sendCenterByForm(this);
                break;
            case "getLossOrderProductList":
                UIWmsLossOrderDetail.getDetailList(this);
                break;
            case "getLossOrderInfo":
                UIWmsLossOrder.getOrder(this);
                break;
            case "getProductCostPrice":
                UIWmsProductCost.getProductCostPrice(this);
                break;
        }
    }
}
