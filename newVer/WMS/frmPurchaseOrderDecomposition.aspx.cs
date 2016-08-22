using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.CRM;
using ZJSIG.UIProcess.BA;

public partial class WMS_frmPurchaseOrderDecomposition : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        script.Append("\r\n");
        script.Append("var dsWarehouseList = ");
        script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        //script.Append("\r\n");
        //script.Append("var dsCustomerList = ");
        //script.Append(UIBusinessCrmCustomer.getTerminalCustomerByOrgListInfoStore(this));

        script.Append("\r\n");
        script.Append("var dsShippingStatusList = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['ShippingStatusId','ShippingStatusName'],\r\n");
        script.Append("data:[['0','正常'],['1','已割完']],\r\n");
        script.Append("autoLoad: false});\r\n");

        script.Append("\r\n");
        script.Append("var dsBillType = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W01"));

        //script.Append("\r\n");
        //script.Append("var dsBillStatus = new Ext.data.SimpleStore({\r\n");
        //script.Append("fields:['BillStatusId','BillStatusName'],\r\n");
        //script.Append("data:[['-1','发运单'],['0','未入仓'],['1','预入仓'],['2','已入仓']],\r\n");
        //script.Append("autoLoad: false});\r\n");

        //script.Append("\r\n");
        //script.Append("var dsSuppliesListInfo = ");
        //script.Append(UIBusinessCrmCustomer.getSuppliesListInfoStore());

        //商品规格
        script.Append("\r\n");
        script.Append("var dsProductSpecList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("B01"));
        //单位
        script.Append("\r\n");
        script.Append("var dsProductUnitList = ");
        script.Append(UIBaProductUnit.getUnitInfoStore());
        //商品列表
        //script.Append("\r\n");
        //script.Append("var dsProductList = ");
        //script.Append( UIBaProduct.getProductListInfoStore( this ) );
        //组织下员工
        //script.Append("\r\n");
        //script.Append("var dsOperationList =");
        //script.Append(UIAdmEmployee.getEmployeeListStore(this));

        //得到下级组织
        //script.Append("\r\n");
        //script.Append("var dsChildOrgList =");
        ////script.Append(UIAdmOrg.getChildOrgListStore(this));
        //script.Append(UIAdmOrg.getOrgListStore(this));

        script.Append("</script>\r\n");
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        string method = Request.QueryString["method"];
        switch (method)
        {
            
            case "getShippingOrderList":
                UIWmsPurchaseOrder.getShippingOrderList(this);
                break;
            case "getShippingOrderDetailList"://得到发运单明细
                UIWmsPurchaseOrderDetail.getDetailList(this);
                break;
            case "getShippingOrder"://得到发运单信息
                UIWmsPurchaseOrder.getOrder(this);
                break;
            case "getPurchaseOrderProductByShippingId"://根据发运单号得到明细记录
                UIWmsPurchaseOrderDetail.getDetailListByShippingId(this);
                break;
            case "savePurchaseOrderInfo"://保存进货单
                UIWmsPurchaseOrder.dowithMultiSpiltShippingOrder(this);
                break;
            //确认发运单分割完成
            case "confirmShippingOrder":
                UIWmsPurchaseOrder.ConfirmShippingOrderCompleteSplit(this);
                break;
            case"cancelShipepingOrder":
                UIWmsPurchaseOrder.CancelPurchaseOrder( this );
                break;
            case "rollbackShipepingOrder":
                UIWmsPurchaseOrder.rollbackPurchaseOrder(this);
                break;
        }
    }
}
