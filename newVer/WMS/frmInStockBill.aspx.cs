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
using ZJSIG.UIProcess.SCM;
using ZJSIG.UIProcess.PMS;

public partial class WMS_frmInStockBill : PageBase
{
    public string type = "";
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        //string FromBillType = Request.QueryString["trye"];
        //bool isEdit = (strId != null && strId.Trim().Length > 0) ? true : false;

        StringBuilder script = new StringBuilder();
        //获取仓库
        script.Append("<script>\r\n");
        script.Append("var dsWarehouseList = ");
        script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        ////获取规格
        //script.Append("\r\n");
        //script.Append("var dsProductSpecList = ");
        //script.Append(UISysDicsInfo.getDicsInfoStore("B01"));
        ////获取商品单位
        //script.Append("\r\n");
        //script.Append("var dsProductUnitList = ");
        //script.Append(UIBaProductUnit.getUnitInfoStore());
        //获取商品列表
        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append(UIWmsStockInout.getProductListInfoStore(this));
        //装卸公司
        script.Append("\r\n");
        script.Append("var dsLoadCompanyList = ");
        script.Append(UIWmsLoadCompany.getLoadCompanyListStore(this));
        //装卸公司
        script.Append("\r\n");
        script.Append("var dsTransCompanyList = ");
        script.Append(UIWmsLoadCompany.getTransCompanyListStore(this));
        //单据类型
        script.Append("\r\n");
        script.Append("var dsBillTypeList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W02"));
        ////供应商
        //script.Append("\r\n");
        //script.Append("var dsSuppliesListInfo = ");
        //script.Append(UIBusinessCrmCustomer.getSuppliesListInfoStore());

        ////客户
        //script.Append("\r\n");
        //script.Append("var dsCustomerListInfo = ");
        //script.Append(UIBusinessCrmCustomer.getCustomerListInfoStore(this));


        //组织
        //script.Append("\r\n");
        //script.Append("var dsOrgListInfo = ");
        //script.Append(UIAdmOrg.getOrgListStore(this));
        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));

        script.Append("</script>\r\n");
        return script.ToString(); 
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        //UIWmsWarehouse.alarmNoCalcWarehouse(this);
        type = Request.QueryString["type"];

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
                //UIWmsWarehouse.alarmIsCalcWarehouseCost(this);
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
            
            case "getAllotOutOrderInfo"://调拨单
                UIWmsAllotOrder.getOrder(this);
                break;
            case "getAllotOrderInListInfo":
                UIWmsAllotOrderDetail.getDetailList(this, false);
                break;
            case "getAllotOrderOutListInfo":
                UIWmsAllotOrderDetail.getDetailList(this,true);
                break;

            case "getReturnOrderListInfo":
                UIWmsReturnOrderDetail.getDetailList(this);
                break;
            case "getReturnOrderInfo":
                UIWmsReturnOrder.getOrder(this);
                break;
            case "getSalesOrderListInfo"://销售单
                UIScmDrawInv.getDrawDtlListByOrderId(this);
                break;
            case "getProduceOrderListInfo"://生产相关
                UIPmsStockOrder.getProduceListByOrderId(this);
                break;
            case"getProductListByOrder":
                string str = UIWmsStockInout.getProductListInfoStore( this );
                //int index = str.IndexOf( "fields:[" );
                //str = str.Substring( index );
                str = str.Substring( 0, str.Length - 3 );
                this.Response.Write( str );
                this.Response.End( );
                break;
        }
    }
}
